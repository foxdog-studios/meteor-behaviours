'use strict';

Package.describe({
  name: 'fds:behaviours',
  summary: "[DON'T USE] Structured code reuse for templates",
  version: '1.1.2',
  git: 'https://github.com/foxdog-studios/meteor-behaviours.git'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.4');
  api.use('coffeescript', 'client');
  api.use('templating', 'client');
  api.use('underscore', 'client');
  api.addFiles([
    'client/lib/export.js',
      'client/lib/abstract_behaviour_factory.coffee',
      'client/lib/behaviour.coffee',
      'client/lib/behaviour_attacher.coffee',
  ], 'client');
  api.export('FDS', 'client');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('fds:behaviours');
});

