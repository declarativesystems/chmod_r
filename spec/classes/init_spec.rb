require 'spec_helper'
describe 'chmod_r' do
  context 'with default values for all parameters' do
    it { should contain_class('chmod_r') }
  end
end
