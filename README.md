# PatchGuard

Stops PatchGuard on the exception path, not by walking every worker.

C++20. Kernel. Paging. A private page for the detour, the original page left for readers.

```text
protected page check
        │
        ▼
   mov cr0  (clear WP)
        │
        ▼
  privileged fault ──► KdpReport hook
        │
        ▼
  rewind stack → park thread
```

## Idea

The check that matters is the same shape every time: validate a protected region, fault, clear `CR0.WP` with `mov cr0`. This sits on that fault.

| Piece | Role |
| --- | --- |
| `KdpReport` hook | first-chance kernel exceptions |
| `mov cr0` filter | only the WP-clear path |
| stack transfer | park the worker with `KeDelayExecutionThread` |
| `KeBugCheckEx` `0x109` | same park if it reaches bugcheck |
| physical page hook | execute from a shadow page |

Other exceptions are ignored.

## Install

Drop this into a driver that already has paging, physical read/write, and a code cave finder. Then:

```cpp
#include "src/pg.hxx"

if ( !pg::install( ) )
    return STATUS_UNSUCCESSFUL;
```

`pg::install` physical-hooks `KeBugCheckEx` and `KdpReport`, then sets `KdpDebugRoutineSelect = 1`.

```cpp
auto* state = pg::hook::physical::create( target, &original );
pg::hook::physical::enable( state, &detour );
```

Integrity reads see the clean page. Execution uses a shadow copy: 14-byte absolute jump, HDE64-aligned NOPs. The park itself is C++ for MSVC x64. No MASM.

## Files

```
src/pg.hxx           pg::install()
src/stack/           RSP switch
src/intercept/       KdpReport and KeBugCheckEx
src/hook/            physical hook and shadow maps
```

Host side, not in this tree: `kernel::*`, `dpm::*`, `paging::*`, `memory::find_cave`, `hde64_disasm`.
