# Compat issues with newer versions of Unity

Use launch options:

```sh
PROTON_USE_WINED3D11=1 PROTON_NO_ESYNC=1 %command%
```

And use [GE-Proton7-55](https://github.com/GloriousEggroll/proton-ge-custom)

```sh
ge-grab.sh -d -v GE-Proton7-55
```

Proton config options: https://github.com/ValveSoftware/Proton#runtime-config-options
