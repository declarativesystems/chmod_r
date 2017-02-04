require 'spec_helper'
describe 'chmod_r', :type => :define do
  let :facts do
    {
      "os" => {
        "family" => "RedHat"
      }
    }
  end
  context 'with default values for all parameters' do
    let :title do
      "/tmp/test"
    end
    let :params do
      {
        :want_mode => "0777",
      }
    end
    it { should compile }
  end
end
