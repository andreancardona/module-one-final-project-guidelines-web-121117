require_relative '../config/environment'

#@API_KEY = '8dQUUUZ8wokkPMjjn2oRxA'

cli = CommandLineInterface.new
current_session = Session.new
cli.greet(current_session)