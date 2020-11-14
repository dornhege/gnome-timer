/*
 * Copyright (c) 2012-2017 gnome-pomodoro contributors
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Kamil Prusko <kamilprusko@gmail.com>
 *
 */

const Signals = imports.signals;
const Gio = imports.gi.Gio;

const Extension = imports.misc.extensionUtils.getCurrentExtension();
const Capabilities = Extension.imports.capabilities;


const ExTimerInterface = '<node> \
<interface name="org.gnome.ExTimer"> \
    <property name="Elapsed" type="d" access="read"/> \
    <property name="State" type="s" access="read"/> \
    <property name="StateDuration" type="d" access="read"/> \
    <property name="IsPaused" type="b" access="read"/> \
    <property name="Version" type="s" access="read"/> \
    <method name="SetState"> \
        <arg type="s" name="state" direction="in" /> \
        <arg type="d" name="timestamp" direction="in" /> \
    </method> \
    <method name="SetStateDuration"> \
        <arg type="s" name="state" direction="in" /> \
        <arg type="d" name="duration" direction="in" /> \
    </method> \
    <method name="ShowMainWindow"> \
        <arg type="s" name="mode" direction="in" /> \
        <arg type="u" name="timestamp" direction="in" /> \
    </method> \
    <method name="ShowPreferences"> \
        <arg type="u" name="timestamp" direction="in" /> \
    </method> \
    <method name="Start"/> \
    <method name="Stop"/> \
    <method name="Reset"/> \
    <method name="Pause"/> \
    <method name="Resume"/> \
    <method name="Skip"/> \
    <method name="Quit"/> \
</interface> \
</node>';

const ExTimerExtensionInterface = '<node> \
<interface name="org.gnome.ExTimer.Extension"> \
    <property name="Capabilities" type="as" access="read"/> \
</interface> \
</node>';


var ExTimerProxy = Gio.DBusProxy.makeProxyWrapper(ExTimerInterface);
function ExTimer(callback, cancellable) {
    return new ExTimerProxy(Gio.DBus.session, 'org.gnome.ExTimer', '/org/gnome/ExTimer', callback, cancellable);
}


var ExTimerExtension = class {
    constructor() {
        this.Capabilities = Capabilities.capabilities;

        this._dbusImpl = Gio.DBusExportedObject.wrapJSObject(ExTimerExtensionInterface, this);
        this._dbusImpl.export(Gio.DBus.session, '/org/gnome/ExTimer/Extension');
        this._dbusId = 0;

        this.initialized = false;
    }

    _onNameAcquired(name) {
        this.initialized = true;

        this.emit('name-acquired');
    }

    _onNameLost(name) {
        this.initialized = false;

        this.emit('name-lost');
    }

    run() {
        if (this._dbusId == 0) {
            this._dbusId = Gio.DBus.session.own_name('org.gnome.ExTimer.Extension',
                                                     Gio.BusNameOwnerFlags.REPLACE,
                                                     this._onNameAcquired.bind(this),
                                                     this._onNameLost.bind(this));
        }
    }

    destroy() {
        this.disconnectAll();

        Gio.DBus.session.unown_name(this._dbusId);

        this._dbusImpl.unexport();

        this.emit('destroy');
    }
};
Signals.addSignalMethods(ExTimerExtension.prototype);
