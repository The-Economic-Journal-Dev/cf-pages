# Check if the dist directory exists, if not, create it
if [ ! -d "dist" ]; then
  echo "Dist folder not present!"
  mkdir dist
fi

# Ensure jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found, installing jq..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        echo "Please install jq manually."
        exit 1
    fi
fi

# Define the root directory and articles directory
ROOT_DIR="$(pwd)"
ARTICLES_DIR="${ROOT_DIR}/articles"
OWNER=The-Economic-Journal-Dev
REPO=cf-pages

# Start the XML output to sitemap.xml in the articles directory
{
echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

# Loop through files in the articles directory
for file in "${ARTICLES_DIR}"/*; do
    # Get just the filename
    filename=$(basename "$file")
    
    if [[ "$filename" != "build.sh" && "$filename" != "404.html" && "$filename" != "sitemap.xml" && -f "$file" ]]; then
        commit_date=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/commits?path=$file&page=1&per_page=1" | \
    grep '"date"' | head -n 1 | cut -d '"' -f 4)
        
        # Remove .html extension if present
        filename_without_extension=${filename%.html}
        
        # Generate the XML for this file
        echo "<url>"
        echo "  <loc>https://www.derpdevstuffs.org/articles/$filename_without_extension</loc>"
        echo "  <lastmod>$commit_date</lastmod>"
        echo "  <changefreq>monthly</changefreq>"
        echo "  <priority>0.7</priority>"
        echo "</url>"
    fi
done

# End the XML output
echo '</urlset>'
} > "${ARTICLES_DIR}/sitemap.xml"

echo "sitemap.xml has been created in the articles directory."

# Check if the articles directory exists
if [ -d "articles" ]; then
  # Move the articles directory into the dist directory
  cp -r articles dist/
  echo "Moved articles directory to dist."
else
  echo "articles directory does not exist."
fi

# Check if the articles directory exists
if [ -d "configs" ]; then
  # Move the articles directory into the dist directory
  cp -r configs/* dist/
  echo "Moved configs files to dist."
else
  echo "configs directory does not exist."
fi
