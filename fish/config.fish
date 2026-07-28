fish_vi_key_bindings

if status is-interactive
# Commands to run in interactive sessions can go here
end

set -gx RAPPI_DEV_URL "https://microservices.dev.rappi.com"
set -gx RAPPI_CO_URL "https://services.grability.rappi.com"
set -gx RAPPI_MX_URL "https://services.mxgrability.rappi.com"
set -gx RAPPI_BR_URL "https://services.rappi.com.br"
set -gx RAPPI_AR_URL "https://services.rappi.com.ar"
set -gx RAPPI_CL_URL "https://services.rappi.cl"
set -gx RAPPI_UY_URL "https://services.rappi.com.uy"
set -gx RAPPI_PE_URL "https://services.rappi.pe"
set -gx RAPPI_CR_URL "https://services.rappi.co.cr"
set -gx RAPPI_EC_URL "https://services.rappi.com.ec"

set -gx RAPPI_URLS \
    DEV=$RAPPI_DEV_URL \
    CO=$RAPPI_CO_URL \
    MX=$RAPPI_MX_URL \
    BR=$RAPPI_BR_URL \
    AR=$RAPPI_AR_URL \
    CL=$RAPPI_CL_URL \
    UY=$RAPPI_UY_URL \
    PE=$RAPPI_PE_URL \
    CR=$RAPPI_CR_URL \
    EC=$RAPPI_EC_URL
