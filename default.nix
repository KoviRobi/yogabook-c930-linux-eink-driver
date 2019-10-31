{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "yogabook-c930-eink-driber-${kernel.version}-${version}";
  version = "unstable-2019-09-05";

  src = ./driver;
  #src = fetchFromGitHub {
  #  owner = "aleksb";
  #  repo = "yogabook-c930-linux-eink-driver";
  #  rev = "9b26a3c706259934c55310d7f7e3846ba00e3337";
  #  sha256 = "1lcp6wllxfm2h3bjq2w9p0nnqw0am7d3mjmki7mgi99dfc1ndqcs";
  #};
  #sourceRoot = "source/driver";

  buildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace ./Makefile --replace '/lib/modules/' "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '`uname -r`' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace 'INSTALL_MOD_PATH=/' "INSTALL_MOD_PATH=$out"
  '';

  meta = with stdenv.lib; {
    description = "Driver for the e-ink keyboard of the Lenovo Yoga Book C930";
    homepage = https://github.com/aleksb/yogabook-c930-linux-eink-driver;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ kovirobi ];
  };
}
