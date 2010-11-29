drush make --working-copy overseer.make ./overseer-profile
rm -Rf ./overseer-profile/sites/all/libraries/ckeditor/_samples
rm -Rf ./overseer-profile/sites/all/libraries/ckeditor/_source
mkdir ./overseer-profile/profiles/overseer
mkdir ./overseer-profile/sites/all/themes
mkdir ./overseer-profile/sites/all/modules/custom
cp ./overseer-profile/sites/default/default.settings.php ./overseer-profile/sites/default/settings.php
cp overseer.profile ./overseer-profile/profiles/overseer/.
mv ./overseer-profile/sites/all/modules/contrib/pathauto/i18n-ascii.example.txt ./overseer-profile/sites/default/i18n-ascii.txt