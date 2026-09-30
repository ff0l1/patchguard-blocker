#pragma once

#include "stack/transfer.hxx"
#include "intercept/handler.hxx"
#include "hook/physical.hxx"
#include "hook/shadow.hxx"

// PatchGuard exception-path blocker.
// Call pg::install() once the host kernel / paging / dpm layers are ready.
namespace pg {
    inline bool install( ) {
        return intercept::install( );
    }
}
