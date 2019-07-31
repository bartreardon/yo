//
//  YoNotification.swift
//  yo
//
//  Created by Shea Craig on 3/3/15.
//  Copyright (c) 2015 Shea Craig. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

class YoCommandLine {
    // Set up our commandline arguments.
    let cli = CommandLine()
    let sender = StringOption(shortFlag: "e", longFlag: "sender", helpMessage: "Set the notification sender ID - Ignored")
    //let banner = BoolOption(shortFlag: "m", longFlag: "banner-mode", helpMessage: "Does not work! Set if you would like to send a non-persistent notification. No buttons will be available if set.")
    let ignoresDoNotDisturb = BoolOption(shortFlag: "d", longFlag: "ignores-do-not-disturb", helpMessage: "Set to make your notification appear even if computer is in do-not-disturb mode.")
    let lockscreenOnly = BoolOption(shortFlag: "l", longFlag: "lockscreen-only", helpMessage: "Set to make your notification appear only if computer is locked. If set, no buttons will be available.")
    let title = StringOption(shortFlag: "t", longFlag: "title", required: true, helpMessage: "Title for notification. REQUIRED.")
    let subtitle = StringOption(shortFlag: "s", longFlag: "subtitle", required: false, helpMessage: "Subtitle for notification.")
    let informativeText = StringOption(shortFlag: "n", longFlag: "info", required: false, helpMessage: "Informative text.")
    let messageText = StringOption(shortFlag: "m", longFlag: "message", required: false, helpMessage: "Message text (same as info).")
    let actionBtnText = StringOption(shortFlag: "b", longFlag: "action-btn", required: false, helpMessage: "Include an action button, with the button label text supplied to this argument.")
    let otherBtnText = StringOption(shortFlag: "o", longFlag: "other-btn", required: false, helpMessage: "Alternate label for cancel button text.")
    let poofsOnCancel = BoolOption(shortFlag: "p", longFlag: "poofs-on-cancel", helpMessage: "Set to make your notification 'poof' when the cancel button is hit.")
    let icon = StringOption(shortFlag: "i", longFlag: "icon", required: false, helpMessage: "Complete path to an alternate icon to use for the notification.")
    let contentImage = StringOption(shortFlag: "c", longFlag: "content-image", required: false, helpMessage: "Path to an image to use for the notification's 'contentImage' property.")
    let deliverySound = StringOption(shortFlag: "z", longFlag: "delivery-sound", required: false, helpMessage: "The name of the sound to play when delivering or 'None'. The name must not include the extension, nor any path components, and should be located in '/Library/Sounds' or '~/Library/Sounds'. (Defaults to the system's default notification sound). See the README for more info.")
    let action = StringOption(shortFlag: "a", longFlag: "action-path", required: false, helpMessage: "Application to open if user selects the action button. Provide the full path as the argument. This option only does something if -b/--action-btn is also specified.")
    let bashAction = StringOption(shortFlag: "B", longFlag: "bash-action", required: false, helpMessage: "Bash script to run. Be sure to properly escape all reserved characters. This option only does something if -b/--action-btn is also specified. Defaults to opening nothing.")
    let version = BoolOption(shortFlag: "v", longFlag: "version", helpMessage: "Display Yo version information.")
    let help = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Show help.")

    init () {
        // Add arguments to commandline object and handle errors or help requests.
        cli.addOptions(title, subtitle, informativeText, messageText, actionBtnText, action, bashAction, otherBtnText, icon, contentImage,  deliverySound, ignoresDoNotDisturb, lockscreenOnly, poofsOnCancel, version, help, sender)
        do {
            try cli.parse()
        } catch {
            // Due to the way required options work in CommandLine, make sure
            // the user wasn't actually trying to get help or version info.
            if !help.value && !version.value {
                cli.printUsage(error)
                exit(EX_USAGE)
            }
        }
        
        // Help and version flags short-circuit other commands and exit:
        if help.value {
            cli.printUsage()
            exit(EX_USAGE)
        } else if version.value {
            if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                print(text)
                exit(0)
            }
            
        }
    }
}
