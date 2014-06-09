module Net
  module Openvpn
    module Errors
      class KeyGeneration < StandardError; end
      class CertificateRevocation < StandardError; end
    end
  end
end