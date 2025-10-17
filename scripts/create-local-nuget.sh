#!/bin/bash

# Create Local NuGet Packages for MedTravel Shared Libraries
# This script builds and creates local NuGet packages for all shared libraries

echo "🚀 Creating Local NuGet Packages for MedTravel Shared Libraries"
echo ""

# Create nupkgs directory if it doesn't exist
NUPKGS_DIR="nupkgs"
if [ ! -d "$NUPKGS_DIR" ]; then
    mkdir -p "$NUPKGS_DIR"
    echo "✅ Created nupkgs directory"
fi

# Function to build and pack a project
build_and_pack() {
    local project_path="$1"
    local project_name="$2"
    
    echo "📦 Building and packing $project_name..."
    
    # Navigate to project directory
    cd "$project_path" || exit 1
    
    # Clean and restore
    echo "  🔄 Cleaning and restoring packages..."
    dotnet clean -c Release --verbosity quiet
    dotnet restore --verbosity quiet
    
    # Build
    echo "  🔨 Building project..."
    dotnet build -c Release --no-restore --verbosity quiet
    
    if [ $? -eq 0 ]; then
        # Pack
        echo "  📦 Creating NuGet package..."
        dotnet pack -c Release --no-build --output "../../../$NUPKGS_DIR" --verbosity quiet
        
        if [ $? -eq 0 ]; then
            echo "  ✅ $project_name package created successfully"
        else
            echo "  ❌ Failed to pack $project_name"
            cd - > /dev/null
            return 1
        fi
    else
        echo "  ❌ Failed to build $project_name"
        cd - > /dev/null
        return 1
    fi
    
    cd - > /dev/null
    return 0
}

# Build packages in dependency order
echo "📋 Building packages in dependency order..."
echo ""

# Array of projects in dependency order
projects=(
    "backend/Shared/MedTravel.Shared:MedTravel.Shared"
    "backend/Shared/MedTravel.Shared.Auth:MedTravel.Shared.Auth"
    "backend/Shared/MedTravel.Shared.Logging:MedTravel.Shared.Logging"
    "backend/Shared/MedTravel.Shared.Validation:MedTravel.Shared.Validation"
)

success_count=0
total_count=${#projects[@]}

for project in "${projects[@]}"; do
    IFS=':' read -r path name <<< "$project"
    if build_and_pack "$path" "$name"; then
        ((success_count++))
    fi
    echo ""
done

# Check results
echo "📊 Build Results:"
echo "  ✅ Successful: $success_count/$total_count"

if [ $success_count -eq $total_count ]; then
    echo ""
    echo "🎉 All NuGet packages created successfully!"
    
    # List created packages
    echo ""
    echo "📦 Created packages:"
    ls -la "$NUPKGS_DIR"/*.nupkg 2>/dev/null | while read -r line; do
        filename=$(basename "$(echo "$line" | awk '{print $NF}')")
        echo "  • $filename"
    done
    
    echo ""
    echo "🔧 Next Steps:"
    echo "  1. Add local feed to NuGet sources:"
    echo "     dotnet nuget add source \"$(pwd)/$NUPKGS_DIR\" --name \"LocalMedTravel\""
    echo ""
    echo "  2. Restore packages in your services:"
    echo "     dotnet restore MedTravel.sln"
    echo ""
    echo "  3. Build the solution:"
    echo "     dotnet build MedTravel.sln"
    
else
    echo ""
    echo "❌ Some packages failed to build. Please check the errors above."
    exit 1
fi

echo ""
echo "✨ Local NuGet packages setup complete!"
