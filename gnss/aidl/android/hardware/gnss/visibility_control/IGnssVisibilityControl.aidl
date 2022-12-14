/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.hardware.gnss.visibility_control;

import android.hardware.gnss.visibility_control.IGnssVisibilityControlCallback;

/**
 * Represents the GNSS location reporting permissions and notification interface.
 *
 * This interface is used to tell the GNSS HAL implementation whether the framework user has
 * granted permission to the GNSS HAL implementation to provide GNSS location information for
 * non-framework (NFW), non-user initiated emergency use cases, and to notify the framework user
 * of these GNSS location information deliveries.
 *
 * For user initiated emergency cases (and for the configured extended emergency session duration),
 * the GNSS HAL implementation must serve the emergency location supporting network initiated
 * location requests immediately irrespective of this permission settings.
 *
 * There is no separate need for the GNSS HAL implementation to monitor the global device location
 * on/off setting. Permission to use GNSS for non-framework use cases is expressly controlled
 * by the method enableNfwLocationAccess(). The framework monitors the location permission settings
 * of the configured proxy applications(s), and device location settings, and calls the method
 * enableNfwLocationAccess() whenever the user control proxy applications have, or do not have,
 * location permission. The proxy applications are used to provide user visibility and control of
 * location access by the non-framework on/off device entities they are representing.
 *
 * For device user visibility, the GNSS HAL implementation must call the method
 * IGnssVisibilityControlCallback.nfwNotifyCb() whenever location request is rejected or
 * location information is provided to non-framework entities (on or off device). This includes
 * the network initiated location requests for user-initiated emergency use cases as well.
 *
 * The HAL implementations that support this interface must not report GNSS location, measurement,
 * status, or other information that can be used to derive user location to any entity when not
 * expressly authorized by this HAL. This includes all endpoints for location information
 * off the device, including carriers, vendors, OEM and others directly or indirectly.
 *
 * @hide
 */
@VintfStability
interface IGnssVisibilityControl {
    /**
     * Enables/disables non-framework entity location access permission in the GNSS HAL.
     *
     * The framework will call this method to update GNSS HAL implementation every time the
     * framework user, through the given proxy application(s) and/or device location settings,
     * explicitly grants/revokes the location access permission for non-framework, non-user
     * initiated emergency use cases.
     *
     * Whenever the user location information is delivered to non-framework entities, the HAL
     * implementation must call the method IGnssVisibilityControlCallback.nfwNotifyCb() to notify
     * the framework for user visibility.
     *
     * @param proxyApps Full list of package names of proxy Android applications representing
     * the non-framework location access entities (on/off the device) for which the framework
     * user has granted non-framework location access permission. The GNSS HAL implementation
     * must provide location information only to non-framework entities represented by these
     * proxy applications.
     *
     * The package name of the proxy Android application follows the standard Java language
     * package naming format. For example, com.example.myapp.
     */
    void enableNfwLocationAccess(in @utf8InCpp String[] proxyApps);

    /**
     * Registers the callback for HAL implementation to use.
     *
     * @param callback Handle to IGnssVisibilityControlCallback interface.
     */
    void setCallback(in IGnssVisibilityControlCallback callback);
}
