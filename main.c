#include <unistd.h>

#include <main.h>

int main(int argc, const char* argv[]) {
  GoString name = {"Jack", 4};
  GoString string = Test(name);
  write(STDOUT_FILENO, string.p, string.n);
  write(STDOUT_FILENO, "\n", 1);
  return 0;
}
