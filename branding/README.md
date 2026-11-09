# Bee Lazy VPN

This is a Bee Lazy branded build profile for the Amnezia VPN client. It keeps the upstream VPN engines and platform integrations, changes the application identity, uses the supplied Bee Lazy logo in the first-run and about screens, and applies a lime accent palette.

The root `CMakeLists.txt` includes `branding/bee-lazy-cache.cmake`, so every build of this fork, including `deploy/build.sh`, is a Bee Lazy build. CI builds are defined in `.github/workflows/bee-lazy.yml`.

The profile supports protocol configurations implemented by the upstream client, including AmneziaWG, WireGuard, OpenVPN, IKEv2, XRay and Shadowsocks. A connection key is protocol-specific; an arbitrary key format cannot be made interchangeable. LG webOS does not provide the native VPN extension used by this client, so an LG television needs a VPN-capable router.

The upstream client is GPL-3.0 licensed and contains third-party components with their own licenses. Before distributing Bee Lazy binaries, preserve the license notices and provide the corresponding source as required by those licenses. Apple distribution also needs Bee Lazy-owned signing identifiers and profiles.
