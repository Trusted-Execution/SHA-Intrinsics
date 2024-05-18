/* sha256.c - SHA reference implementation using C            */
/*   Written and placed in public domain by Jeffrey Walton    */


// clang -march=native -mtune=native -o sha256 sha256.c
// Size (-O0):  0x0431 @  953000 hashes/sec
// Size (-O1):  0x02bf @ 2123000 hashes/sec
// Size (-O2):  0x027c @ 2111000 hashes/sec
// Size (-O3):  0x027c @ 3264000 hashes/sec 
// Size (-Os):  0x0277 @ 2115000 hashes/sec
// Size (-Oz):  0x0260 @ 2134000 haehes/sec



#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <x86intrin.h>
#include <stdlib.h>
#include <time.h>

static const uint32_t _Alignas(8) K256[] =
{
    0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5,
    0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5,
    0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3,
    0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174,
    0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC,
    0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
    0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7,
    0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967,
    0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13,
    0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85,
    0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3,
    0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
    0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5,
    0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3,
    0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208,
    0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2
};

#define ROTATE(x,y)  (((x)>>(y)) | ((x)<<(32-(y))))
#define Sigma0(x)    (ROTATE((x), 2) ^ ROTATE((x),13) ^ ROTATE((x),22))
#define Sigma1(x)    (ROTATE((x), 6) ^ ROTATE((x),11) ^ ROTATE((x),25))
#define sigma0(x)    (ROTATE((x), 7) ^ ROTATE((x),18) ^ ((x)>> 3))
#define sigma1(x)    (ROTATE((x),17) ^ ROTATE((x),19) ^ ((x)>>10))

#define Ch(x,y,z)    (((x) & (y)) ^ ((~(x)) & (z)))
#define Maj(x,y,z)   (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))

// Avoid undefined behavior                   
// https://stackoverflow.com/q/29538935/608639
// 
// The function costs us 478 - 431 = 0x47 (71) bytes 
//uint32_t B2U32(uint8_t val, uint8_t sh) {
//    return ((uint32_t)val) << sh;
//}

#define B2U32( val, sh ) (((uint32_t)val) << sh)


/* Process multiple blocks. The caller is responsible for setting the initial */
/*  state, and the caller is responsible for padding the final block.        */
void sha256_process( uint32_t state[8], const uint8_t data[], uint32_t length )
{
    uint32_t _Alignas(8) a;
    uint32_t _Alignas(8) b;
    uint32_t _Alignas(8) c;
    uint32_t _Alignas(8) d;
    uint32_t _Alignas(8) e;
    uint32_t _Alignas(8) f;
    uint32_t _Alignas(8) g;
    uint32_t _Alignas(8) h;
    uint32_t _Alignas(8) s0;
    uint32_t _Alignas(8) s1;
    uint32_t _Alignas(8) T2;
    uint32_t _Alignas(8) T1;
    uint32_t _Alignas(8) X[16];
    uint32_t _Alignas(8) i;

    size_t _Alignas(8) blocks = length / 64;
    while (blocks--)
    {
        a = state[0];
        b = state[1];
        c = state[2];
        d = state[3];
        e = state[4];
        f = state[5];
        g = state[6];
        h = state[7];

        for (i = 0; i < 16; i++)
        {
            X[i] = B2U32(data[0], 24) | B2U32(data[1], 16) | B2U32(data[2], 8) | B2U32(data[3], 0);
            data += 4;

            T1 = h;
            T1 += Sigma1(e);
            T1 += Ch(e, f, g);
            T1 += K256[i];
            T1 += X[i];

            T2 = Sigma0(a);
            T2 += Maj(a, b, c);

            h = g;
            g = f;
            f = e;
            e = d + T1;
            d = c;
            c = b;
            b = a;
            a = T1 + T2;
        }

        for (; i < 64; i++)
        {
            s0 = X[(i + 1) & 0x0f];
            s0 = sigma0(s0);
            s1 = X[(i + 14) & 0x0f];
            s1 = sigma1(s1);

            T1 = X[i & 0xf] += s0 + s1 + X[(i + 9) & 0xf];
            T1 += h + Sigma1(e) + Ch(e, f, g) + K256[i];
            T2 = Sigma0(a) + Maj(a, b, c);
            h = g;
            g = f;
            f = e;
            e = d + T1;
            d = c;
            c = b;
            b = a;
            a = T1 + T2;
        }

        state[0] += a;
        state[1] += b;
        state[2] += c;
        state[3] += d;
        state[4] += e;
        state[5] += f;
        state[6] += g;
        state[7] += h;
    }
}


void genHash( char* str ) {
   uint8_t _Alignas(8) message[64];
   memset( message, 0x00, sizeof(message) );

   uint64_t _Alignas(8) length = strlen( str );
   
   if( length > 55 ) {
      fprintf( stderr, "Unable to process messages > 55 characters long\n" );
      exit( EXIT_FAILURE );
   }

   // The message can be up to 55 bytes long... 1 byte for a marker and the last 8 bytes are for padding/length
   
   strncpy( (char*)message, str, 55 );
    
   message[length] = 0x80;     // The padding marker
   message[63] = length << 3;  // The valid number of bits in the message

    // initial state
    //
    // Historical note:  It's the first 32 bits of the fractional parts of the
    // square roots of the first 8 primes 2..19):
    uint32_t state[8] = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    };

    sha256_process(state, message, sizeof(message));

    const uint8_t b1 = (uint8_t)(state[0] >> 24);
    const uint8_t b2 = (uint8_t)(state[0] >> 16);
    const uint8_t b3 = (uint8_t)(state[0] >>  8);
    const uint8_t b4 = (uint8_t)(state[0] >>  0);
    const uint8_t b5 = (uint8_t)(state[1] >> 24);
    const uint8_t b6 = (uint8_t)(state[1] >> 16);
    const uint8_t b7 = (uint8_t)(state[1] >>  8);
    const uint8_t b8 = (uint8_t)(state[1] >>  0);

    printf( "SHA256 hash of %s: ", str );

    printf("%08x%08x%08x%08x%08x%08x%08x%08x\n",
        state[0], state[1], state[2], state[3], state[4], state[5], state[6], state[7] );

}


/// Get a random number (`static inline`)
///
/// @return A 64-bit random number
static inline uint64_t get_random64() {
   uint64_t rval;

   asm volatile (
       "rdrand %0;"
      :"=r" (rval)  // Output
      :             // Input
      :"cc"   );    // Clobbers

   return rval;
}


void loadTest( const uint32_t iterations ) {
   uint64_t _Alignas( 8 ) ticks = 0;
   
   union msg_u {
      uint8_t each[64];
      uint64_t u64[8];
   };

   union msg_u _Alignas( 8 ) message;
   size_t _Alignas(8) length;
   
   for( int i = 0 ; i < iterations ; i++ ) {
      message.u64[0] = get_random64();
      message.u64[1] = get_random64();
      message.u64[2] = get_random64();
      message.u64[3] = get_random64();
      message.u64[4] = get_random64();
      message.u64[5] = get_random64();
      message.u64[6] = get_random64();
      message.u64[7] = get_random64();

      uint32_t _Alignas( 8 ) state[8] = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
      };

//    uint64_t _Alignas( 8 ) startTime = __rdtsc();

      sha256_process( state, &message.each[0], 64 );
      
//    uint64_t _Alignas( 8 ) endTime = __rdtsc();
      
//    ticks += (endTime - startTime);
   }
// printf( "Ticks %lu\n", ticks );
}


int main( int argc, char* argv[] ) {
       
   genHash( argv[1] );

   clock_t stop_time = clock() + CLOCKS_PER_SEC;
   uint32_t n = 0;
   
   while( clock() <= stop_time ) {   
      loadTest( 1000 );
      n += 1000;
   }
   printf( "%u SHA256 hashes per second\n", n );
   
       
   return EXIT_SUCCESS;
}
