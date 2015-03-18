'use strict';

Package.describe({
  name: 'fds:behaviours',
  summary: 'Structured code reuse for templates',
  version: '3.0.0',
  documentation: null,
  git: 'https://github.com/foxdog-studios/meteor-behaviours.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.4.1');
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

