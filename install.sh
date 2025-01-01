
echo "Installing .configs"
rsync -avP ./.config/ ~/.config/
echo "Installing scripts"
rsync -avP ./Scripts ~/Scripts

echo "Completed"