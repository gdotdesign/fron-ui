require 'spec_helper'

describe UI::Notifications do
  it 'should display notifications' do
    expect {
      subject.push 'Test'
    }.to change { subject.children.count }.from(0).to(1)
  end

  it 'should remove notificaion' do
    noti = subject.push 'Test'
    expect {
      noti.trigger :animationend, animationName: 'ui-notification-show'
      noti.trigger :animationend, animationName: 'ui-notification-hide'
    }.to change { noti.parent }.from(subject).to(nil)
  end
end
