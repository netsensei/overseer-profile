<?php

/*
  DOCUMENTATION:
    http://drupalcode.org/viewvc/drupal/contributions/modules/drush_make/README.txt?view=markup&pathrev=DRUPAL-6--2
    http://drupal.org/node/67921
    http://drupal.org/project/install_profile_api
    http://api.drupal.org/api/drupal/developer--example.profile/6/source
*/

/**
* Return a description of the profile for the initial installation screen.
*
* @return
*   An array with keys 'name' and 'description' describing this profile.
*/
function overseer_profile_details() {
  return array(
    'name' => 'Overseer profile',
    'description' => 'This profile will install a Drupal as a basic project/issue tracker.',
  );
}

/**
* Return an array of the modules to be enabled when this profile is installed.
*
* @return
*  An array of modules to be enabled.
*/
function overseer_profile_modules() {
  return array(
    // Enable required core modules first.
    'block', 'filter', 'node', 'system', 'user',
    
    // Enable optional core modules
    'comment', 'color', 'syslog', 'help', 'menu', 'path', 'taxonomy', 'update', 'upload', 'dblog',
    
    // Third party modules
    'comment_upload', 'token', 'pathauto', 'views', 'admin_menu',
    
    // project
    'project_issue', 'project',
  );
}

function overseer_profile_tasks(&$task, $url) {
  if ($task == 'profile') {
    // administration theme
    variable_set('admin_theme', 'garland');
    variable_set('node_admin_theme', TRUE);
    
    // user registration
    variable_set('user_register', FALSE);
  
    // files
    variable_set('file_directory_temp', '/tmp');
    variable_set('file_directory_path', 'sites/default/files');

    // date & time
    variable_set('configurable_timezones', 0);

    variable_set('date_format_short', 'd/m/Y - H:i');
    variable_set('date_format_short_custom', 'd/m/Y - H:i');

    variable_set('date_format_media', 'D, d/m/Y - H:i');
    variable_set('date_format_media_custom', 'D, d/m/Y - H:i');

    variable_set('date_format_long', 'l, j F, Y - H:i');
    variable_set('date_format_long_custom', 'l, j F, Y - H:i');

    // error reporting
    variable_set('error_level', 0);

    // roles
    db_query("INSERT INTO {role} (name) VALUES ('%s')", 'site administrator');
    db_query("INSERT INTO {role} (name) VALUES ('%s')", 'editor');

    // pathauto
    variable_set('pathauto_node_pattern', '');
    variable_set('pathauto_taxonomy_pattern', '');
    variable_set('pathauto_user_pattern', '');
    variable_set('pathauto_ignore_words', '');
    variable_set('pathauto_transliterate', FALSE);
    variable_set('pathauto_update_action', 3); // Create a new alias. Redirect from old alias.    

    // permissions
    $admin_permissions = array('access administration menu', 'administer blocks', 'use PHP for block visibility', 'access ckeditor', 'administer menu', 'bypass mollom protection', 'access content', 'administer nodes', 'revert revisions', 'view revisions', 'administer url aliases', 'create url aliases', 'search content', 'use advanced search', 'access administration pages', 'access site reports', 'administer taxonomy', 'access user profiles', 'administer permissions', 'administer users', 'access all webform results', 'access own webform results', 'access own webform submissions', 'delete all webform submissions', 'delete own webform submissions', 'edit all webform submissions', 'edit own webform submissions');
    $editor_permissions = array('access administration menu', 'access ckeditor', 'administer menu', 'bypass mollom protection', 'access content', 'administer nodes', 'revert revisions', 'view revisions', 'search content', 'use advanced search', 'access administration pages', 'access own webform results');
    _overseer_add_permissions(3, $admin_permissions);
    _overseer_add_permissions(4, $editor_permissions);
    
    // set the site frontpage
    variable_set('site_frontpage', 'project/issues');
   
    // create the issues folder
    $directory = file_create_path('issues');
    if (file_check_directory($directory, FILE_CREATE_DIRECTORY, NULL)) {
      variable_set('project_directory_issues', 'issues');
    }
    
    // Update the menu router information.
    menu_rebuild();
  }
}

function _overseer_add_permissions($rid, $perms) {
  // Retrieve the currently set permissions.
  $result = db_query("SELECT p.perm FROM {role} r INNER JOIN {permission} p ON p.rid = r.rid WHERE r.rid = %d ", $rid);
  $existing_perms = array();
  while ($row = db_fetch_object($result)) {
    $existing_perms += explode(', ', $row->perm);
  }
  // If this role already has permissions, merge them with the new permissions being set.
  if (count($existing_perms) > 0) {
    $perms = array_unique(array_merge($perms, (array)$existing_perms));
  }

  // Update the permissions.
  db_query('DELETE FROM {permission} WHERE rid = %d', $rid);
  db_query("INSERT INTO {permission} (rid, perm) VALUES (%d, '%s')", $rid, implode(', ', $perms));
}