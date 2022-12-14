/*
 * Copyright 2019, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ANDROID_HARDWARE_IDENTITY_IDENTITYCREDENTIALSTORE_H
#define ANDROID_HARDWARE_IDENTITY_IDENTITYCREDENTIALSTORE_H

#include <aidl/android/hardware/identity/BnIdentityCredentialStore.h>
#include <aidl/android/hardware/security/keymint/IRemotelyProvisionedComponent.h>

#include "SecureHardwareProxy.h"

namespace aidl::android::hardware::identity {

using ::android::sp;
using ::android::hardware::identity::SecureHardwareProxyFactory;
using ::std::optional;
using ::std::shared_ptr;
using ::std::string;
using ::std::vector;

class IdentityCredentialStore : public BnIdentityCredentialStore {
  public:
    // If remote key provisioning is supported, pass the service name for the correct
    // IRemotelyProvisionedComponent to the remotelyProvisionedComponent parameter. Else
    // pass std::nullopt to indicate remote key provisioning is not supported.
    IdentityCredentialStore(sp<SecureHardwareProxyFactory> hwProxyFactory,
                            optional<string> remotelyProvisionedComponent);

    // The GCM chunk size used by this implementation is 64 KiB.
    static constexpr size_t kGcmChunkSize = 64 * 1024;

    // Methods from IIdentityCredentialStore follow.
    ndk::ScopedAStatus getHardwareInformation(HardwareInformation* hardwareInformation) override;

    ndk::ScopedAStatus createCredential(
            const string& docType, bool testCredential,
            shared_ptr<IWritableIdentityCredential>* outWritableCredential) override;

    ndk::ScopedAStatus getCredential(CipherSuite cipherSuite, const vector<uint8_t>& credentialData,
                                     shared_ptr<IIdentityCredential>* outCredential) override;

    ndk::ScopedAStatus createPresentationSession(
            CipherSuite cipherSuite, shared_ptr<IPresentationSession>* outSession) override;

    ndk::ScopedAStatus getRemotelyProvisionedComponent(
            shared_ptr<::aidl::android::hardware::security::keymint::IRemotelyProvisionedComponent>*
                    outRemotelyProvisionedComponent) override;

  private:
    sp<SecureHardwareProxyFactory> hwProxyFactory_;
    optional<string> remotelyProvisionedComponentName_;
    HardwareInformation hardwareInformation_;
};

}  // namespace aidl::android::hardware::identity

#endif  // ANDROID_HARDWARE_IDENTITY_IDENTITYCREDENTIALSTORE_H
