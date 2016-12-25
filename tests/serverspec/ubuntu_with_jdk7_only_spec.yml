require 'spec_helper'
require 'serverspec'

packages = [ "openjdk-7-jdk" ]

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end
