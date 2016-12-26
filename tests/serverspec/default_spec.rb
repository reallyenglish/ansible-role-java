require 'spec_helper'
require 'serverspec'

packages = []

case os[:family]
when "freebsd"
  packages = [ "java/openjdk7", "java/openjdk8-jre" ]
when "centos"
  packages = [ "java-1.7.0-openjdk" ]
when "openbsd"
  packages = [ "jdk-1.7.0.80p1v0" ]
when "ubuntu"
  if os[:release].to_f < 16.04
    packages = [ "oracle-java8-installer", "openjdk-7-jdk" ]
  else
    packages = [ "openjdk-8-jdk" ]
  end
end

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

case os[:family]
when "freebsd"
  describe file("/proc") do
    # XXX https://github.com/reallyenglish/ansible-role-logstash/issues/7
    # it { should be_mounted.with(:type => "procfs") }
    it { should be_mounted }
  end

  describe file("/dev/fd") do
    # XXX https://github.com/reallyenglish/ansible-role-logstash/issues/7
    # it { should be_mounted.with(:type => "fdescfs") }
    it { should be_mounted }
  end
when "ubuntu"
  if os[:release].to_f < 16.04
    describe command("debconf-show oracle-java8-installer") do
      its(:stdout) { should match(/#{ Regexp.escape("* shared/accepted-oracle-license-v1-1: true") }/) }
      its(:stderr) { should match(/^$/) }
      its(:exit_status) { should eq 0 }
    end
  else
    describe command("debconf-show oracle-java8-installer") do
      its(:stdout) { should match(/^$/) }
      its(:stderr) { should match(/^$/) }
      its(:exit_status) { should eq 0 }
    end
  end
end
