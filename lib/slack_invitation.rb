$LOAD_PATH.unshift File.dirname(__FILE__)

module SlackInvitation
  autoload :Invitator, 'slack_invitation/invitator'
end
