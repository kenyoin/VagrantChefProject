# Debian�n��RedHat�n�ŁA�Ή����قȂ镔���𕪊򂵂܂��B
case node['platform']
###
### Ubuntu �̐ݒ�
###
when 'ubuntu'
  execute 'apt-get update' do
    command 'apt-get update'
    ignore_failure true
    action :run
  end

  %w{
    language-pack-ja-base
    language-pack-ja
  }.each do |pkgname|
    package "#{pkgname}" do
      action :install
    end
  end

  execute 'update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja' do
    command 'update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"'
    ignore_failure true
    action :run
  end

###
### RedHat/CentOS�̐ݒ�
###
when 'centos','redhat'
  execute 'yum update' do
    command 'yum update -y'
    ignore_failure true
    action :run
  end
  #
  # RedHat/CentOS 7 ���烍�P�[���ݒ肪�ς�����̂ŁA�����ŕ��򂵂܂��B
  # 
  if node['platform_version'].to_i == 7 then
    package 'man-pages-ja.noarch' do
      action :install
    end
    execute 'localectl set-locale LANG=ja_JP.UTF-8' do
      command 'localectl set-locale LANG=ja_JP.UTF-8'
      action :run
    end
  else
    # �����炪 RedHat/CentOS 6 �ɑΉ����镔���ł��B
    execute 'yum -y groupinstall "Japanese Support"' do
      command 'yum -y groupinstall "Japanese Support"'
      ignore_failure true
      action :run
    end
    bash "change locale" do
      code <<-EOC
        sed -i.org -e "s/en_US.UTF-8/ja_JP.UTF-8/g" /etc/sysconfig/i18n
      EOC
    end
  end

end # node['platform']

#
# ������́ADebian/Ubuntu RedHat/CentOS �ŋ��ʕ����ł�
# �^�C���]�[���̐ݒ�
script "Change TIMEZONE " do
  interpreter "bash"
  user        "root"
  code <<-EOL
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOL
end