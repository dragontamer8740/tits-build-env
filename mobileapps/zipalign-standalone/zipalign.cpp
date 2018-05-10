/* usage: zipalign [unalignedInput] [alignedOutput] [force] *
 * where input and output are char arrays (strings), and    *
 * force is 1 for overwriting, 0 to not clobber existing.   *
 * ALL INPUTS ARE REQUIRED FOR CORRECT OPERATION. THIS HAS  *
 * ZERO PROTECTION/SAFETY MECHANISMS AND WILL SEGFAULT IF   *
 * YOU DO NOT DO THIS. IT IS MEANT FOR SCRIPTING MAINLY.    */

/* compiles with:

 g++ -I/directory/with/zipalign/header -L/directory/with/libzipalign/library zipalign.cpp -o zipalign -lz -lzipalign

*/

#include <stdio.h>
#include <stdlib.h> /* for atoi */
#include <zipalign.h>

int main(int argc, char *argv[]){
  /* "4" means 32-bit aligned. */
  zipalign(argv[1],argv[2],4,atoi(argv[3]));
  return 0;
}
