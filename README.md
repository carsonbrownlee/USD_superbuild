# USD_superbuild

CMake Superbuild for Universal Scene Description (USD)

Currently this is pre-alpha and I have put it out for community involvement and development.  It likely *will* break on your system and for your specific required options, so please fix or add those options in and add a pull request to get your changes in.  Windows/Macos support need to be added, along with support for many USD options.

Tested with Arch Linux

# Building


```

git clone https://github.com/carsonbrownlee/USD_superbuild.git

cd USD_superbuild

cmake ..

optional (ccmake .. and set options)

cmake --build .
```
