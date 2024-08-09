# Check if the dist directory exists, if not, create it
if [ ! -d "dist" ]; then
  echo "Dist folder not present!"
  mkdir dist
fi

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
