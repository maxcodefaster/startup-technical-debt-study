#!/bin/bash

# Enhanced Clone Script for Open Source Startups' Repositories
# This script creates a directory structure for analyzing technical debt in open source startups
# Created for technical debt research project on startups founded 2010-2020 with venture funding

# Set the base directory for all repositories
BASE_DIR="open_source_startups"

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default mode (not dry run)
DRY_RUN=false

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            echo "Usage: $0 [--dry-run]"
            echo "  --dry-run  Check repository URLs without cloning"
            echo "  --help     Show this help message"
            exit 0
            ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    echo -e "${BLUE}Running in DRY RUN mode - will check URLs but not clone repositories${NC}"
else
    # Create the base directory if it doesn't exist
    mkdir -p "$BASE_DIR"
    echo -e "${GREEN}Created base directory: $BASE_DIR${NC}"
fi

# Initialize counters for summary
TOTAL_REPOS=0
VALID_REPOS=0
INVALID_REPOS=0
EXISTING_REPOS=0

# Array to store invalid repository URLs
declare -a INVALID_REPOS_LIST

# Function to create metadata file with founding year and funding info
create_metadata() {
    local company_dir="$1"
    local company_name="$2"
    local founded="$3"
    local funding="$4"
    
    # Create metadata file
    cat > "$company_dir/metadata.txt" << EOF
Company: $company_name
Founded: $founded
Funding: $funding
EOF
}

# Function to check if a repository URL is valid
check_repo_url() {
    local repo_url="$1"
    
    if git ls-remote "$repo_url" &>/dev/null; then
        return 0 # Valid
    else
        return 1 # Invalid
    fi
}

# Function to clone a repository
clone_repo() {
    local company_name="$1"
    local repo_url="$2"
    local founded="$3"
    local funding="$4"
    
    # Increment total repos counter
    TOTAL_REPOS=$((TOTAL_REPOS + 1))
    
    # Create a sanitized directory name (replace spaces and special chars with underscores)
    local dir_name=$(echo "$company_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_-')
    local company_dir="$BASE_DIR/$dir_name"
    
    # Check if repository URL is valid
    if ! check_repo_url "$repo_url"; then
        echo -e "${RED}❌ Invalid repository URL for $company_name: $repo_url${NC}"
        INVALID_REPOS=$((INVALID_REPOS + 1))
        INVALID_REPOS_LIST+=("$company_name: $repo_url")
        return 1
    fi
    
    VALID_REPOS=$((VALID_REPOS + 1))
    
    # If in dry run mode, just report and exit
    if [ "$DRY_RUN" = true ]; then
        echo -e "${GREEN}✓ Valid repository URL: $company_name - $repo_url${NC}"
        return 0
    fi
    
    # Check if repository already exists
    if [ -d "$company_dir/repo/.git" ]; then
        echo -e "${YELLOW}⚠️ Repository for $company_name already exists, skipping clone${NC}"
        EXISTING_REPOS=$((EXISTING_REPOS + 1))
        return 0
    fi
    
    # Create the company directory
    mkdir -p "$company_dir"
    
    echo -e "${BLUE}Cloning $company_name repository (founded: $founded)...${NC}"
    
    # Clone the repository into the company directory
    if git clone "$repo_url" "$company_dir/repo" 2>/dev/null; then
        echo -e "${GREEN}✅ Successfully cloned $company_name repository${NC}"
        # Create metadata file
        create_metadata "$company_dir" "$company_name" "$founded" "$funding"
    else
        echo -e "${RED}❌ Failed to clone $company_name repository. Please check the URL or your internet connection.${NC}"
        # Remove the directory if clone failed
        rm -rf "$company_dir"
    fi
    
    # Add a small delay to avoid overwhelming GitHub API
    sleep 2
}

echo -e "${BLUE}Starting repository validation/cloning process...${NC}"
echo -e "${BLUE}This script covers startups founded between 2010-2023 with venture funding${NC}"
echo ""

# GitLab
clone_repo "GitLab" "https://github.com/gitlabhq/gitlabhq" "2011" "Raised $400M+ before IPO"

# Cockroach Labs
clone_repo "Cockroach Labs" "https://github.com/cockroachdb/cockroach" "2015" "$355M venture funding"

# Dagster
clone_repo "Dagster" "https://github.com/dagster-io/dagster" "2018" "$48.8M+ venture funding"

# Grafana Labs
clone_repo "Grafana Labs" "https://github.com/grafana/grafana" "2014" "$165M+ venture funding"

# Hasura
clone_repo "Hasura" "https://github.com/hasura/graphql-engine" "2017" "$100M venture funding"

# Supabase
clone_repo "Supabase" "https://github.com/supabase/supabase" "2020" "$36M+ venture funding"

# Confluent
clone_repo "Confluent" "https://github.com/confluentinc/kafka" "2014" "$455M+ before IPO"

# Timescale
clone_repo "Timescale" "https://github.com/timescale/timescaledb" "2015" "$40M+ venture funding"

# Mattermost
clone_repo "Mattermost" "https://github.com/mattermost/mattermost" "2015" "$70M+ venture funding"

# Sentry
clone_repo "Sentry" "https://github.com/getsentry/sentry" "2012" "$127M venture funding"

# Ghost
clone_repo "Ghost" "https://github.com/TryGhost/Ghost" "2013" "Self-funded, $4M+ revenue"

# Kong
clone_repo "Kong" "https://github.com/Kong/kong" "2017" "$171M venture funding"

# Dgraph
clone_repo "Dgraph" "https://github.com/dgraph-io/dgraph" "2015" "$25M venture funding"

# n8n
clone_repo "n8n" "https://github.com/n8n-io/n8n" "2019" "$12M+ venture funding"

# Nextcloud
clone_repo "Nextcloud" "https://github.com/nextcloud/server" "2016" "Venture backed"

# Strapi
clone_repo "Strapi" "https://github.com/strapi/strapi" "2015" "$14M venture funding"

# Metabase
clone_repo "Metabase" "https://github.com/metabase/metabase" "2014" "$53M+ venture funding"

# SiFive
clone_repo "SiFive" "https://github.com/sifive/freedom" "2015" "$64M+ venture funding"

# Crate.io
clone_repo "Crate.io" "https://github.com/crate/crate" "2013" "$31M venture funding"

# MindsDB
clone_repo "MindsDB" "https://github.com/mindsdb/mindsdb" "2017" "$55M+ venture funding"

# Redash
clone_repo "Redash" "https://github.com/getredash/redash" "2013" "Acquired by Databricks"

# InfluxData
clone_repo "InfluxData" "https://github.com/influxdata/influxdb" "2012" "$120M+ venture funding"

# Yugabyte
clone_repo "Yugabyte" "https://github.com/yugabyte/yugabyte-db" "2016" "$47M+ venture funding"

# Platform.sh
clone_repo "Platform.sh" "https://github.com/platformsh/platformsh-cli" "2010" "$50M+ venture funding"

# Posthog
clone_repo "Posthog" "https://github.com/PostHog/posthog" "2020" "$27M+ venture funding"

# Appsmith
clone_repo "Appsmith" "https://github.com/appsmithorg/appsmith" "2019" "$41M+ venture funding"

# Appwrite
clone_repo "Appwrite" "https://github.com/appwrite/appwrite" "2019" "$27M+ venture funding"

# Nhost
clone_repo "Nhost" "https://github.com/nhost/nhost" "2019" "$3M+ venture funding"

# Discourse
clone_repo "Discourse" "https://github.com/discourse/discourse" "2013" "$20M+ venture funding"

# Airbyte
clone_repo "Airbyte" "https://github.com/airbytehq/airbyte" "2020" "$181M venture funding"

# Starburst
clone_repo "Starburst" "https://github.com/starburstdata/trino" "2017" "$164M+ venture funding"

# Apollo GraphQL
clone_repo "Apollo GraphQL" "https://github.com/apollographql/apollo-server" "2016" "$48M+ venture funding"

# Prefect
clone_repo "Prefect" "https://github.com/PrefectHQ/prefect" "2018" "$11.5M+ venture funding"

# Plausible
clone_repo "Plausible" "https://github.com/plausible/analytics" "2019" "Self-funded, growing revenue"

# MeiliSearch
clone_repo "MeiliSearch" "https://github.com/meilisearch/meilisearch" "2018" "$15M venture funding"

# Novu
clone_repo "Novu" "https://github.com/novuhq/novu" "2021" "$6.6M+ venture funding"

# SuperTokens
clone_repo "SuperTokens" "https://github.com/supertokens/supertokens-core" "2019" "$2.5M+ venture funding"

# Rudderstack
clone_repo "Rudderstack" "https://github.com/rudderlabs/rudder-server" "2019" "$56M venture funding"

# Directus
clone_repo "Directus" "https://github.com/directus/directus" "2016" "$7M+ venture funding"

# Jitsi
clone_repo "Jitsi" "https://github.com/jitsi/jitsi-meet" "2013" "Acquired by Atlassian"

# Cal.com
clone_repo "Cal.com" "https://github.com/calcom/cal.com" "2019" "$7.4M+ venture funding"

# Tyk
clone_repo "Tyk" "https://github.com/TykTechnologies/tyk" "2014" "$35M+ venture funding"

# Builder.io
clone_repo "Builder.io" "https://github.com/BuilderIO/builder" "2019" "Top ROSS index startup 2022"

# Cloud9
clone_repo "Cloud9" "https://github.com/c9/core" "2010" "Acquired by Amazon"

# Ionic
clone_repo "Ionic" "https://github.com/ionic-team/ionic-framework" "2012" "$18M+ venture funding"

# OpenFin
clone_repo "OpenFin" "https://github.com/openfin/symphony-of" "2010" "$25M+ venture funding"

# Typesense
clone_repo "Typesense" "https://github.com/typesense/typesense" "2015" "Venture backed"

# Taiga
clone_repo "Taiga" "https://github.com/taigaio/taiga-back" "2014" "$2.6M venture funding"

# Streamlit
clone_repo "Streamlit" "https://github.com/streamlit/streamlit" "2018" "Acquired by Snowflake"

# Signoz
clone_repo "Signoz" "https://github.com/SigNoz/signoz" "2020" "$2M+ venture funding"

# Chatwoot
clone_repo "Chatwoot" "https://github.com/chatwoot/chatwoot" "2017" "$1.6M+ venture funding"

# Rocket.Chat
clone_repo "Rocket.Chat" "https://github.com/RocketChat/Rocket.Chat" "2015" "$27M+ venture funding"

# Jina AI
clone_repo "Jina AI" "https://github.com/jina-ai/jina" "2020" "Venture backed"

# Zammad
clone_repo "Zammad" "https://github.com/zammad/zammad" "2016" "Venture backed"

# OpenProject
clone_repo "OpenProject" "https://github.com/opf/openproject" "2012" "Self-funded"

# CrowdSec
clone_repo "CrowdSec" "https://github.com/crowdsecurity/crowdsec" "2020" "$14M venture funding"

# Hugging Face
clone_repo "Hugging Face" "https://github.com/huggingface/transformers" "2016" "$160M+ venture funding"

# Safing
clone_repo "Safing" "https://github.com/safing/portmaster" "2017" "Top ROSS index startup 2022"

# Entando
clone_repo "Entando" "https://github.com/entando/app-builder" "2010" "$11.5M+ venture funding"

# Mage.ai
clone_repo "Mage.ai" "https://github.com/mage-ai/mage-ai" "2020" "$15M+ venture funding"

# Budibase
clone_repo "Budibase" "https://github.com/Budibase/budibase" "2019" "$7M+ venture funding"

# Windmill
clone_repo "Windmill" "https://github.com/windmill-labs/windmill" "2020" "$3M+ venture funding"

# Chronosphere
clone_repo "Chronosphere" "https://github.com/chronosphereio/chronoctl-core" "2019" "$343M venture funding"

# TerminusDB
clone_repo "TerminusDB" "https://github.com/terminusdb/terminusdb" "2017" "$4.3M venture funding"

# Harness
clone_repo "Harness" "https://github.com/harness/harness" "2016" "$195M+ venture funding"

# QuestDB
clone_repo "QuestDB" "https://github.com/questdb/questdb" "2019" "$15M venture funding"

# Hydra
clone_repo "Hydra" "https://github.com/ory/hydra" "2015" "$12.5M venture funding"

# Temporal
clone_repo "Temporal" "https://github.com/temporalio/temporal" "2019" "$103M+ venture funding"

# Teleport
clone_repo "Teleport" "https://github.com/gravitational/teleport" "2015" "$169M+ venture funding"

# Penpot
clone_repo "Penpot" "https://github.com/penpot/penpot" "2020" "$8M+ venture funding"

# Added repositories from the complete list

# LangChain
clone_repo "LangChain" "https://github.com/langchain-ai/langchain" "2022" "$25M+ venture funding"

# Refine
clone_repo "Refine" "https://github.com/refinedev/refine" "2021" "$1M+ venture funding"

# Lightdash
clone_repo "Lightdash" "https://github.com/lightdash/lightdash" "2021" "$8.4M venture funding"

# FerretDB
clone_repo "FerretDB" "https://github.com/FerretDB/FerretDB" "2021" "Venture backed"

# Chainguard
clone_repo "Chainguard" "https://github.com/chainguard-dev/enforcer" "2021" "$55M+ venture funding"

# Baserow
clone_repo "Baserow" "https://github.com/bram2w/baserow" "2020" "$5M+ venture funding"

# Appflowy
clone_repo "Appflowy" "https://github.com/AppFlowy-IO/AppFlowy" "2021" "$1.6M+ venture funding"

# Plane
clone_repo "Plane" "https://github.com/makeplane/plane" "2022" "Venture backed"

# Infisical
clone_repo "Infisical" "https://github.com/Infisical/infisical" "2022" "$6.8M venture funding"

# Grafbase
clone_repo "Grafbase" "https://github.com/grafbase/grafbase" "2021" "$7.3M venture funding"

# Automatisch
clone_repo "Automatisch" "https://github.com/automatisch/automatisch" "2021" "Venture backed"

# BoxyHQ
clone_repo "BoxyHQ" "https://github.com/boxyhq/jackson" "2021" "$1.2M+ venture funding"

# Superblocks
clone_repo "Superblocks" "https://github.com/superblocksteam/superblocks" "2020" "$37M venture funding"

# Meshery
clone_repo "Meshery" "https://github.com/meshery/meshery" "2019" "Venture backed"

# Superface
clone_repo "Superface" "https://github.com/superfaceai/parser" "2020" "$3.5M venture funding"

# Bytebase
clone_repo "Bytebase" "https://github.com/bytebase/bytebase" "2020" "$12M+ venture funding"

# Kyverno
clone_repo "Kyverno" "https://github.com/kyverno/kyverno" "2019" "Nirmata-backed"

# Linen
clone_repo "Linen" "https://github.com/Linen-dev/linen.dev" "2020" "Venture backed"

# Langflow
clone_repo "Langflow" "https://github.com/langflow-ai/langflow" "2023" "Venture backed"

# Pinecone
clone_repo "Pinecone" "https://github.com/pinecone-io/pinecone-ts" "2019" "$138M venture funding"

# Ollama
clone_repo "Ollama" "https://github.com/ollama/ollama" "2023" "Top ROSS index startup 2024"

# Zed
clone_repo "Zed" "https://github.com/zed-industries/zed" "2018" "Top ROSS index startup 2024"

# Immich
clone_repo "Immich" "https://github.com/immich-app/immich" "2022" "Venture backed"

# Astro
clone_repo "Astro" "https://github.com/withastro/astro" "2021" "$7M venture funding"

# Print summary
echo ""
echo -e "${BLUE}======= Repository Cloning Summary =======${NC}"
echo -e "${BLUE}Total repositories: $TOTAL_REPOS${NC}"
echo -e "${GREEN}Valid repository URLs: $VALID_REPOS${NC}"
echo -e "${RED}Invalid repository URLs: $INVALID_REPOS${NC}"

if [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}Existing repositories skipped: $EXISTING_REPOS${NC}"
fi

# Print list of invalid repositories if any
if [ ${#INVALID_REPOS_LIST[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Invalid repositories:${NC}"
    for repo in "${INVALID_REPOS_LIST[@]}"; do
        echo -e "${RED}  - $repo${NC}"
    done
fi

echo ""
if [ "$DRY_RUN" = true ]; then
    echo -e "${GREEN}Dry run completed. Run without --dry-run to actually clone repositories.${NC}"
else
    echo -e "${GREEN}Repository cloning process completed!${NC}"
    echo -e "${GREEN}Check the '$BASE_DIR' directory for all repositories.${NC}"
    echo -e "${GREEN}Each repository includes a metadata.txt file with founding year and funding information.${NC}"
fi