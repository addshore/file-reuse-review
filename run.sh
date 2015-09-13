#!/bin/bash

RemoteRepo="git://github.com/wmde/Lizenzverweisgenerator.git"
MainDirectory="master"
Date=`date +%Y-%m-%d:%H:%M:%S`

# Pull master

echo -e "\e[33m==== Updating test directory ===="

if [ ! -d "$MainDirectory" ]; then
	echo "Main directory '$MainDirectory' does not exist!"
	git clone $RemoteRepo master
else
	echo "Main directory '$MainDirectory' exists!"
fi

git -C master fetch --all
git -C master reset --hard origin/master

# Checkout all branches

for ref in $(git -C master for-each-ref --format='%(refname)' refs/remotes/origin); do
    ref=${ref:20}

	if [ "$ref" != "HEAD" ] && [ "$ref" != "master" ]; then
		echo -e "\e[33m== Syncing $ref =="
	
		if [ ! -d "$ref" ]; then
			echo "Copying whole master repo dir to branch dir"
			cp -r ./master ./$ref
			cp -r ./master/.git ./$ref/.git
		else
			echo "Copying git dir to branch dir"
			rm -rf ./$ref/.git
			cp -r ./master/.git ./$ref/.git
		fi

		git -C $ref checkout -f origin/$ref
	fi

done

# Make some index page

cp /dev/null index.html
echo '<html><head></head><body>' >> index.html
echo '<h1>AG Branch review tool</h1>' >> index.html
echo '<p>Please select a branch to review from below:</p>' >> index.html
echo '<ul>' >> index.html
for ref in $(git -C master for-each-ref --format='%(refname)' refs/remotes/origin); do
    ref=${ref:20}
	if [ "$ref" != "HEAD" ]; then
		echo "<li>" >> index.html
		echo "<a href='$ref'>$ref</a> <a href='$ref/redesign'>(redesign)</a>" >> index.html
		echo "</li>" >> index.html
	fi
done
echo '</ul>' >> index.html
echo "<p>Last updated on: $Date UTC</p>" >> index.html
echo '<p>You can update these copies by <a href="run.php">clicking here</a></p>' >> index.html
echo '</body></html>' >> index.html
