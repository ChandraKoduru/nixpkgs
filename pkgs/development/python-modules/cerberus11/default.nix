{ stdenv, buildPythonPackage, fetchPypi, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "302e6694f206dd85cb63f13fd5025b31ab6d38c99c50c6d769f8fa0b0f299589";
  };

  checkInputs = [ pytestrunner pytest ];

  meta = with stdenv.lib; {
    homepage = http://python-cerberus.org/;
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
