require 'spec_helper'
require 'serverspec'

packages = []

case os["family"]
when "freebsd"
  packages = [ "java/openjdk7", "java/openjdk8-jre" ]
when "centos"
  packages = [ "java-1.7.0-openjdk" ]
end

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

case os["family"]
when "freebsd"
  describe "/proc" do
    it { should be_mounted.with(:type => "procfs") }
  end

  describe "/dev/fd" do
    it { shoulld be_mounted.with(:type => "fdescfs") }
  end
end
