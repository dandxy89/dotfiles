#!/bin/bash

echo "Updating vim.pack plugins..."
cd ~/.local/share/nvim/site/pack/plugins/start

for dir in */; do
    if [ -d "$dir/.git" ]; then
        echo "Updating $dir..."
        cd "$dir"
        git pull --ff-only
        cd ..
    fi
done

# Rebuild rust plugins after update
echo "Rebuilding Rust plugins..."
if [ -d "blink.cmp" ]; then
    cd blink.cmp && cargo build --release && cd ..
fi
if [ -d "blink.pairs" ]; then
    cd blink.pairs && cargo build --release && cd ..
fi

echo "Plugin update complete!"