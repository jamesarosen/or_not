# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_pants_or_not_session',
  :secret => 'fa2fcb962e988b923703156fff1b60ac36ec4b30dc28166b2500529704bb338bb3a8309c68d0c31f122eaf00e9565dc2503f776480c7b17d930bd61a3860a4eb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
