#include <cstdint>
#include <cstdio>

namespace ff0l {
constexpr std::uint32_t k_version = 1;
}

int main() {
    std::printf("%u\n", static_cast<unsigned>(ff0l::k_version));
    return 0;
}