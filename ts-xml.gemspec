# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ts-xml}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Edgars Beigarts"]
  s.date = %q{2009-12-09}
  s.description = %q{Support for Oracle, SQLite3 using xmlpipe2 for Thinking Sphinx}
  s.email = %q{1@wb4.lv}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    "LICENSE",
     "README.textile",
     "lib/thinking_sphinx/xml.rb",
     "lib/thinking_sphinx/xml/adapters/abstract_adapter.rb",
     "lib/thinking_sphinx/xml/adapters/oracle_adapter.rb",
     "lib/thinking_sphinx/xml/adapters/sqlite3_adapter.rb",
     "lib/thinking_sphinx/xml/source.rb",
     "lib/thinking_sphinx/xml/tasks.rb"
  ]
  s.homepage = %q{http://github.com/ebeigarts/ts-xml}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Thinking Sphinx - XML}
  s.test_files = [
    "features/alternate_primary_key.feature",
     "features/attribute_transformation.feature",
     "features/attribute_updates.feature",
     "features/deleting_instances.feature",
     "features/direct_attributes.feature",
     "features/excerpts.feature",
     "features/extensible_delta_indexing.feature",
     "features/facets.feature",
     "features/facets_across_model.feature",
     "features/handling_edits.feature",
     "features/retry_stale_indexes.feature",
     "features/searching_across_models.feature",
     "features/searching_by_index.feature",
     "features/searching_by_model.feature",
     "features/searching_with_find_arguments.feature",
     "features/sphinx_detection.feature",
     "features/sphinx_scopes.feature",
     "features/step_definitions",
     "features/step_definitions/alpha_steps.rb",
     "features/step_definitions/beta_steps.rb",
     "features/step_definitions/common_steps.rb",
     "features/step_definitions/extensible_delta_indexing_steps.rb",
     "features/step_definitions/facet_steps.rb",
     "features/step_definitions/find_arguments_steps.rb",
     "features/step_definitions/gamma_steps.rb",
     "features/step_definitions/scope_steps.rb",
     "features/step_definitions/search_steps.rb",
     "features/step_definitions/sphinx_steps.rb",
     "features/sti_searching.feature",
     "features/support",
     "features/support/database.example.yml",
     "features/support/db",
     "features/support/db/fixtures",
     "features/support/db/fixtures/alphas.rb",
     "features/support/db/fixtures/authors.rb",
     "features/support/db/fixtures/betas.rb",
     "features/support/db/fixtures/boxes.rb",
     "features/support/db/fixtures/categories.rb",
     "features/support/db/fixtures/cats.rb",
     "features/support/db/fixtures/comments.rb",
     "features/support/db/fixtures/developers.rb",
     "features/support/db/fixtures/dogs.rb",
     "features/support/db/fixtures/extensible_betas.rb",
     "features/support/db/fixtures/foxes.rb",
     "features/support/db/fixtures/gammas.rb",
     "features/support/db/fixtures/people.rb",
     "features/support/db/fixtures/posts.rb",
     "features/support/db/fixtures/robots.rb",
     "features/support/db/fixtures/tags.rb",
     "features/support/db/migrations",
     "features/support/db/migrations/create_alphas.rb",
     "features/support/db/migrations/create_animals.rb",
     "features/support/db/migrations/create_authors.rb",
     "features/support/db/migrations/create_authors_posts.rb",
     "features/support/db/migrations/create_betas.rb",
     "features/support/db/migrations/create_boxes.rb",
     "features/support/db/migrations/create_categories.rb",
     "features/support/db/migrations/create_comments.rb",
     "features/support/db/migrations/create_developers.rb",
     "features/support/db/migrations/create_extensible_betas.rb",
     "features/support/db/migrations/create_gammas.rb",
     "features/support/db/migrations/create_people.rb",
     "features/support/db/migrations/create_posts.rb",
     "features/support/db/migrations/create_robots.rb",
     "features/support/db/migrations/create_taggings.rb",
     "features/support/db/migrations/create_tags.rb",
     "features/support/env.rb",
     "features/support/lib",
     "features/support/lib/generic_delta_handler.rb",
     "features/support/models",
     "features/support/models/alpha.rb",
     "features/support/models/animal.rb",
     "features/support/models/author.rb",
     "features/support/models/beta.rb",
     "features/support/models/box.rb",
     "features/support/models/cat.rb",
     "features/support/models/category.rb",
     "features/support/models/comment.rb",
     "features/support/models/developer.rb",
     "features/support/models/dog.rb",
     "features/support/models/extensible_beta.rb",
     "features/support/models/fox.rb",
     "features/support/models/gamma.rb",
     "features/support/models/person.rb",
     "features/support/models/post.rb",
     "features/support/models/robot.rb",
     "features/support/models/tag.rb",
     "features/support/models/tagging.rb",
     "spec/cucumber_env.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thinking-sphinx>, [">= 1.3.8"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
    else
      s.add_dependency(%q<thinking-sphinx>, [">= 1.3.8"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
    end
  else
    s.add_dependency(%q<thinking-sphinx>, [">= 1.3.8"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
  end
end