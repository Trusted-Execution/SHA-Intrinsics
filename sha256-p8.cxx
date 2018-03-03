/* sha256-p8.c - Power8 SHA extensions using C intrinsics     */
/*   Written and placed in public domain by Jeffrey Walton    */

/* xlC -qarch=pwr8 -qaltivec sha256-p8.cxx -o sha256-p8.exe   */
/* g++ -mcpu=power8 sha256-p8.cxx -o sha256-p8.exe            */

#include <stdio.h>
#include <string.h>
#include <stdint.h>

#if defined(__ALTIVEC__)
# include <altivec.h>
# undef vector
# undef pixel
# undef bool
#endif

#if defined(__xlc__) || defined(__xlC__)
# define TEST_SHA_XLC 1
#elif defined(__clang__)
# define TEST_SHA_CLANG 1
#elif defined(__GNUC__)
# define TEST_SHA_GCC 1
#endif

#define A16 __attribute__((aligned(16)))
typedef __vector unsigned char uint8x16_p8;
typedef __vector unsigned int  uint32x4_p8;

// Load unaligned
uint32x4_p8 VectorLoad32x4(const uint32_t val[4])
{
    const uint32x4_p8 v1 = vec_ld( 0, (uint32_t*)val);
    const uint32x4_p8 v2 = vec_ld(16, (uint32_t*)val);
    const uint8x16_p8 vp = vec_lvsl(0, (uint32_t*)val);
    return vec_perm(v1,v2,vp);
}

uint32x4_p8 VectorCh(const uint32x4_p8 a, const uint32x4_p8 b, const uint32x4_p8 c)
{
    return vec_sel(a,b,c);
}

uint32x4_p8 VectorMaj(const uint32x4_p8 a, const uint32x4_p8 b, const uint32x4_p8 c)
{
    const uint32x4_p8 x = vec_xor(a,b);
    return vec_sel(x,b,c);
}

uint32x4_p8 Vector_sigma0(const uint32x4_p8 val)
{
#if defined(TEST_SHA_GCC)
    return __builtin_crypto_vshasigmaw(val, 0, 0);
#elif defined(TEST_SHA_XLC)
    return __vshasigmaw(val, 0, 0);
#endif
}

uint32x4_p8 Vector_sigma1(const uint32x4_p8 val)
{
#if defined(TEST_SHA_GCC)
    return __builtin_crypto_vshasigmaw(val, 0, 1);
#elif defined(TEST_SHA_XLC)
    return __vshasigmaw(val, 1, 0);
#endif
}

uint32x4_p8 VectorSigma0(const uint32x4_p8 val)
{
#if defined(TEST_SHA_GCC)
    return __builtin_crypto_vshasigmaw(val, 1, 0);
#elif defined(TEST_SHA_XLC)
    return __vshasigmaw(val, 1, 0);
#endif
}

uint32x4_p8 VectorSigma1(const uint32x4_p8 val)
{
#if defined(TEST_SHA_GCC)
    return __builtin_crypto_vshasigmaw(val, 1, 0xf);
#elif defined(TEST_SHA_XLC)
    return __vshasigmaw(val, 1, 0xf);
#endif
}

static const uint32_t K256[] =
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

void SHA256_SCHEDULE(uint32_t W[64], const uint8_t* data)
{
#if defined(__LITTLE_ENDIAN__)
    for (unsigned int i=0; i<64; i+=4)
    {
        const uint8x16_p8 zero = {0};
        const uint8x16_p8 mask = {3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12};
        vec_vsx_st((uint32x4_p8)vec_perm((uint8x16_p8)vec_vsx_ld(i*4, data), zero, mask), i*4, W);
    }
#else
    // memcpy(W, data, 64);
    for (unsigned int i=0; i<64; i+=4)
    {
        vec_vsx_st((uint32x4_p8)vec_vsx_ld(i*4, data), i*4, W);
    }
#endif

    for (unsigned int i = 16; i < 64; ++i)
    {
        const uint32x4_p8 s0 = Vector_sigma0(vec_splats(W[i-15]));
        const uint32x4_p8 x0 = vec_splats(W[i-16]);
        const uint32x4_p8 s1 = Vector_sigma1(vec_splats(W[i-2]));
        const uint32x4_p8 x1 = vec_splats(W[i-7]);

        W[i] = vec_extract(
            vec_add(s1, vec_add(x1, vec_add(s0, x0))), 0
        );
    }
}

template <unsigned int R>
static inline
void SHA256_ROUND(const uint32_t W[64],
        uint32x4_p8& a, uint32x4_p8& b,    uint32x4_p8& c, uint32x4_p8& d,
        uint32x4_p8& e,    uint32x4_p8& f, uint32x4_p8& g,    uint32x4_p8& h )
{
    uint32x4_p8 T1, T2;
    
    // T1 = h + Sigma1(e) + Ch(e,f,g) + K[t] + W[t]
    T1 = h;
    T1 = vec_add(T1, VectorSigma1(e));
    T1 = vec_add(T1, VectorCh(e,f,g));
    T1 = vec_add(T1, vec_splats(K256[R]));
    T1 = vec_add(T1, vec_splats(W[R]));

    // T2 = Sigma0(a) + Maj(a,b,c)
    T2 = VectorSigma0(a);
    T2 = vec_add(T2, VectorMaj(a,b,c));

    h = g; g = f; f = e;
    e = vec_add(d, T1);
    d = c; c = b; b = a;
    a = vec_add(T1, T2);
}

/* Process multiple blocks. The caller is resonsible for setting the initial */
/*  state, and the caller is responsible for padding the final block.        */
void sha256_process_p8(uint32_t state[8], const uint8_t data[], uint32_t length)
{    
    uint32_t blocks = length / 64;
    if (!blocks) return;

    while (blocks--)
    {
        uint32_t W[64];
        SHA256_SCHEDULE(W, data);
        data += 64;            
        
        const uint32x4_p8 ad = vec_vsx_ld( 0, state);
        const uint32x4_p8 eh = vec_vsx_ld(16, state);        
        uint32x4_p8 a,b,c,d,e,f,g,h;

        a = vec_vspltw(ad, 0);
        b = vec_vspltw(ad, 1);
        c = vec_vspltw(ad, 2);
        d = vec_vspltw(ad, 3);
        e = vec_vspltw(eh, 0);
        f = vec_vspltw(eh, 1);
        g = vec_vspltw(eh, 2);
        h = vec_vspltw(eh, 3);

        SHA256_ROUND< 0>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 1>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 2>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 3>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 4>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 5>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 6>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 7>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 8>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND< 9>(W, a,b,c,d,e,f,g,h);
        
        SHA256_ROUND<10>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<11>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<12>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<13>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<14>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<15>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<16>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<17>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<18>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<19>(W, a,b,c,d,e,f,g,h);

        SHA256_ROUND<20>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<21>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<22>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<23>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<24>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<25>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<26>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<27>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<28>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<29>(W, a,b,c,d,e,f,g,h);

        SHA256_ROUND<30>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<31>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<32>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<33>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<34>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<35>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<36>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<37>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<38>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<39>(W, a,b,c,d,e,f,g,h);

        SHA256_ROUND<40>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<41>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<42>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<43>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<44>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<45>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<46>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<47>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<48>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<49>(W, a,b,c,d,e,f,g,h);

        SHA256_ROUND<50>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<51>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<52>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<53>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<54>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<55>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<56>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<57>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<58>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<59>(W, a,b,c,d,e,f,g,h);

        SHA256_ROUND<60>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<61>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<62>(W, a,b,c,d,e,f,g,h);
        SHA256_ROUND<63>(W, a,b,c,d,e,f,g,h);

        state[0] += vec_extract(a, 0);
        state[1] += vec_extract(b, 0);
        state[2] += vec_extract(c, 0);
        state[3] += vec_extract(d, 0);
        state[4] += vec_extract(e, 0);
        state[5] += vec_extract(f, 0);
        state[6] += vec_extract(g, 0);
        state[7] += vec_extract(h, 0);
    }
}

#if defined(TEST_MAIN)

#include <stdio.h>
#include <string.h>
int main(int argc, char* argv[])
{
    /* empty message with padding */
    uint8_t message[64];
    memset(message, 0x00, sizeof(message));
    message[0] = 0x80;

    /* intial state */
    uint32_t state[8] = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19};

    sha256_process_p8(state, message, sizeof(message));

    /* E3B0C44298FC1C14... */
    printf("SHA256 hash of empty message: ");
    printf("%02X%02X%02X%02X%02X%02X%02X%02X...\n",
        (state[0] >> 24) & 0xFF, (state[0] >> 16) & 0xFF, (state[0] >> 8) & 0xFF, (state[0] >> 0) & 0xFF,
        (state[1] >> 24) & 0xFF, (state[1] >> 16) & 0xFF, (state[1] >> 8) & 0xFF, (state[1] >> 0) & 0xFF);

    int success = (((state[0] >> 24) & 0xFF) == 0xE3) && (((state[0] >> 16) & 0xFF) == 0xB0) &&
        (((state[0] >> 8) & 0xFF) == 0xC4) && (((state[0] >> 0) & 0xFF) == 0x42);

    if (success)
        printf("Success!\n");
    else
        printf("Failure!\n");

    return (success != 0 ? 0 : 1);
}

#endif