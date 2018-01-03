require_relative '../config/environment'

#@API_KEY = '8dQUUUZ8wokkPMjjn2oRxA'

# comment out the next line to re-enable SQL logging
ActiveRecord::Base.logger.level = 1

cli = CommandLineInterface.new
current_session = Session.new
cli.session = current_session
cli.greet