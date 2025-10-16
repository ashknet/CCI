#!/bin/bash

# =============================================
# MedTravel Platform - Database Setup Script
# Runs all SQL scripts to create databases
# =============================================

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================"
echo "  MedTravel Database Setup"
echo "======================================${NC}"
echo ""

# SQL Server connection details
SQL_SERVER="${SQL_SERVER:-localhost}"
SQL_USER="${SQL_USER:-sa}"
SQL_PASSWORD="${SQL_PASSWORD:-YourStrong@Passw0rd}"

echo -e "${YELLOW}Server: ${SQL_SERVER}${NC}"
echo -e "${YELLOW}User: ${SQL_USER}${NC}"
echo ""

# Navigate to script directory
cd "$(dirname "$0")"

# Function to run SQL script
run_sql() {
    local script=$1
    local description=$2
    
    echo -e "${BLUE}Running: ${description}${NC}"
    
    if command -v sqlcmd &> /dev/null; then
        sqlcmd -S "$SQL_SERVER" -U "$SQL_USER" -P "$SQL_PASSWORD" -i "$script" -b
    else
        echo -e "${YELLOW}sqlcmd not found. Using docker exec...${NC}"
        docker exec -i medtravel-sqlserver /opt/mssql-tools/bin/sqlcmd \
            -S localhost -U sa -P "$SQL_PASSWORD" -i "/tmp/$script" -b
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ ${description} - SUCCESS${NC}"
    else
        echo -e "${RED}❌ ${description} - FAILED${NC}"
        exit 1
    fi
    echo ""
}

# =============================================
# 1. USER MANAGEMENT DATABASE
# =============================================
echo -e "${BLUE}======================================"
echo "  1. User Management Database"
echo "======================================${NC}"

run_sql "UserManagement/01-Schema/01-CreateTables.sql" "Creating tables"
run_sql "UserManagement/02-StoredProcedures/01-UserProcedures.sql" "Creating stored procedures"
run_sql "UserManagement/03-SampleData/01-InsertSampleData.sql" "Inserting sample data"

echo -e "${GREEN}✅ UserManagementDb complete${NC}"
echo ""

# =============================================
# 2. HOSPITAL SERVICE DATABASE
# =============================================
echo -e "${BLUE}======================================"
echo "  2. Hospital Service Database"
echo "======================================${NC}"

run_sql "Hospital/01-Schema/01-CreateTables.sql" "Creating tables"
run_sql "Hospital/02-StoredProcedures/01-SearchProcedures.sql" "Creating stored procedures"
run_sql "Hospital/03-SampleData/01-InsertSampleData.sql" "Inserting sample data"

echo -e "${GREEN}✅ HospitalDb complete${NC}"
echo ""

# =============================================
# 3. TASERVICE DATABASE
# =============================================
echo -e "${BLUE}======================================"
echo "  3. TAService Database"
echo "======================================${NC}"

run_sql "TAService/01-Schema/01-CreateTables.sql" "Creating tables"
run_sql "TAService/02-StoredProcedures/01-BookingProcedures.sql" "Creating stored procedures"
run_sql "TAService/03-SampleData/01-InsertSampleData.sql" "Inserting sample data"

echo -e "${GREEN}✅ TAServiceDb complete${NC}"
echo ""

# =============================================
# 4. MESSAGING SERVICE DATABASE
# =============================================
echo -e "${BLUE}======================================"
echo "  4. Messaging Service Database"
echo "======================================${NC}"

run_sql "Messaging/01-Schema/01-CreateTables.sql" "Creating tables"

echo -e "${GREEN}✅ MessagingDb complete${NC}"
echo ""

# =============================================
# SUMMARY
# =============================================
echo -e "${BLUE}======================================"
echo "  Database Setup Complete!"
echo "======================================${NC}"
echo ""
echo -e "${GREEN}✅ UserManagementDb - 13 tables, 8 SPs${NC}"
echo -e "${GREEN}✅ HospitalDb - 15 tables, 7 SPs${NC}"
echo -e "${GREEN}✅ TAServiceDb - 8 tables, 4 SPs${NC}"
echo -e "${GREEN}✅ MessagingDb - 4 tables${NC}"
echo ""
echo -e "${BLUE}Total: 40 tables, 19 stored procedures${NC}"
echo ""
echo "Next steps:"
echo "  1. Update connection strings in appsettings.json"
echo "  2. Start services: docker-compose up"
echo "  3. Access APIs at http://localhost:500x/swagger"
echo ""
