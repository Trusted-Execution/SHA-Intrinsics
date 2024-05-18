clear 
while true
do
   # clang -Oz -march=native -mtune=native -o sha256-x86 sha256-x86.c && nice -20 ./sha256-x86 "I am Sam" && (objdump --syms sha256-x86 | grep "sha256_process_x86";)

   clang -Oz -march=native -mtune=native -o sha256 sha256.c && nice -20 ./sha256 "I am Sam" && (objdump --syms sha256 | grep "sha256_process";)
done
