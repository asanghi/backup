# encoding: utf-8

require 'fileutils'
require 'yaml'

##
# The Backup Ruby Gem
module Backup

  ##
  # List the available database, storage, compressor, encryptor and notifier constants.
  # These are used to dynamically define these constants as classes inside Backup::Finder
  # to provide a nicer configuration file DSL syntax to the users. Adding existing constants
  # to the arrays below will enable the user to use a constant instead of a string.
  # Example, instead of:
  #  database "MySQL" do |mysql|
  # You can do:
  #  database MySQL do |mysql|
  DATABASES   = ['MySQL', 'PostgreSQL', 'MongoDB', 'Redis']
  STORAGES    = ['S3', 'CloudFiles', 'Dropbox', 'FTP', 'SFTP', 'SCP', 'RSync']
  COMPRESSORS = ['Gzip']
  ENCRYPTORS  = ['OpenSSL', 'GPG']
  NOTIFIERS   = ['Mail']

  ##
  # Backup's internal paths
  LIBRARY_PATH       = File.join(File.dirname(__FILE__), 'backup')
  CONFIGURATION_PATH = File.join(LIBRARY_PATH, 'configuration')
  STORAGE_PATH       = File.join(LIBRARY_PATH, 'storage')
  DATABASE_PATH      = File.join(LIBRARY_PATH, 'database')
  COMPRESSOR_PATH    = File.join(LIBRARY_PATH, 'compressor')
  ENCRYPTOR_PATH     = File.join(LIBRARY_PATH, 'encryptor')
  NOTIFIER_PATH      = File.join(LIBRARY_PATH, 'notifier')

  ##
  # Backup's Environment paths
  PATH               = File.join(ENV['HOME'], 'Backup')
  DATA_PATH          = File.join(ENV['HOME'], 'Backup', 'data')
  CONFIG_FILE        = File.join(ENV['HOME'], 'Backup', 'config.rb')
  LOG_PATH           = File.join(ENV['HOME'], 'Backup', 'log')
  TMP_PATH           = File.join(ENV['HOME'], 'Backup', '.tmp')

  ##
  # Autoload Backup base files
  autoload :Model,   File.join(LIBRARY_PATH, 'model')
  autoload :Archive, File.join(LIBRARY_PATH, 'archive')
  autoload :CLI,     File.join(LIBRARY_PATH, 'cli')
  autoload :Finder,  File.join(LIBRARY_PATH, 'finder')
  autoload :Logger,  File.join(LIBRARY_PATH, 'logger')
  autoload :Version, File.join(LIBRARY_PATH, 'version')

  ##
  # Autoload Backup configuration files
  module Configuration
    autoload :Base,     File.join(CONFIGURATION_PATH, 'base')
    autoload :Helpers,  File.join(CONFIGURATION_PATH, 'helpers')

    module Notifier
      autoload :Base, File.join(CONFIGURATION_PATH, 'notifier', 'base')
      autoload :Mail, File.join(CONFIGURATION_PATH, 'notifier', 'mail')
    end

    module Encryptor
      autoload :Base,    File.join(CONFIGURATION_PATH, 'encryptor', 'base')
      autoload :OpenSSL, File.join(CONFIGURATION_PATH, 'encryptor', 'open_ssl')
      autoload :GPG,     File.join(CONFIGURATION_PATH, 'encryptor', 'gpg')
    end

    module Compressor
      autoload :Base, File.join(CONFIGURATION_PATH, 'compressor', 'base')
      autoload :Gzip, File.join(CONFIGURATION_PATH, 'compressor', 'gzip')
    end

    module Storage
      autoload :Base,       File.join(CONFIGURATION_PATH, 'storage', 'base')
      autoload :S3,         File.join(CONFIGURATION_PATH, 'storage', 's3')
      autoload :CloudFiles, File.join(CONFIGURATION_PATH, 'storage', 'cloudfiles')
      autoload :Dropbox,    File.join(CONFIGURATION_PATH, 'storage', 'dropbox')
      autoload :FTP,        File.join(CONFIGURATION_PATH, 'storage', 'ftp')
      autoload :SFTP,       File.join(CONFIGURATION_PATH, 'storage', 'sftp')
      autoload :SCP,        File.join(CONFIGURATION_PATH, 'storage', 'scp')
      autoload :RSync,      File.join(CONFIGURATION_PATH, 'storage', 'rsync')
    end

    module Database
      autoload :Base,       File.join(CONFIGURATION_PATH, 'database', 'base')
      autoload :MySQL,      File.join(CONFIGURATION_PATH, 'database', 'mysql')
      autoload :PostgreSQL, File.join(CONFIGURATION_PATH, 'database', 'postgresql')
      autoload :MongoDB,    File.join(CONFIGURATION_PATH, 'database', 'mongodb')
      autoload :Redis,      File.join(CONFIGURATION_PATH, 'database', 'redis')
    end
  end

  ##
  # Autoload Backup storage files
  module Storage
    autoload :Base,       File.join(STORAGE_PATH, 'base')
    autoload :Object,     File.join(STORAGE_PATH, 'object')
    autoload :S3,         File.join(STORAGE_PATH, 's3')
    autoload :CloudFiles, File.join(STORAGE_PATH, 'cloudfiles')
    autoload :Dropbox,    File.join(STORAGE_PATH, 'dropbox')
    autoload :FTP,        File.join(STORAGE_PATH, 'ftp')
    autoload :SFTP,       File.join(STORAGE_PATH, 'sftp')
    autoload :SCP,        File.join(STORAGE_PATH, 'scp')
    autoload :RSync,      File.join(STORAGE_PATH, 'rsync')
  end

  ##
  # Autoload Backup database files
  module Database
    autoload :Base,       File.join(DATABASE_PATH, 'base')
    autoload :MySQL,      File.join(DATABASE_PATH, 'mysql')
    autoload :PostgreSQL, File.join(DATABASE_PATH, 'postgresql')
    autoload :MongoDB,    File.join(DATABASE_PATH, 'mongodb')
    autoload :Redis,      File.join(DATABASE_PATH, 'redis')
  end

  ##
  # Autoload compressor files
  module Compressor
    autoload :Base, File.join(COMPRESSOR_PATH, 'base')
    autoload :Gzip, File.join(COMPRESSOR_PATH, 'gzip')
  end

  ##
  # Autoload encryptor files
  module Encryptor
    autoload :Base,    File.join(ENCRYPTOR_PATH, 'base')
    autoload :OpenSSL, File.join(ENCRYPTOR_PATH, 'open_ssl')
    autoload :GPG,     File.join(ENCRYPTOR_PATH, 'gpg')
  end

  ##
  # Autoload notification files
  module Notifier
    autoload :Base,   File.join(NOTIFIER_PATH, 'base')
    autoload :Binder, File.join(NOTIFIER_PATH, 'binder')
    autoload :Mail,   File.join(NOTIFIER_PATH, 'mail')
  end

  ##
  # Dynamically defines all the available database, storage, compressor, encryptor and notifier
  # classes inside Backup::Finder to improve the DSL for the configuration file
  (DATABASES + STORAGES + COMPRESSORS + ENCRYPTORS + NOTIFIERS).each do |constant|
    Backup::Finder.const_set(constant, Class.new)
  end

end
