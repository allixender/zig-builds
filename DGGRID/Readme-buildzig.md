# A cross-compile experiment with 

Would be great if cross compile would already work, but seems the C/C++ std includes problematic:

```bash
zig build -Dtarget=x86_64-linux -Dcpu=x86_64 -Doptimize=ReleaseSafe

zig build -Dtarget=x86_64-windows -Dcpu=x86_64_v3 -Doptimize=ReleaseSafe
```
