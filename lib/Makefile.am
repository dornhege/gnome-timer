lib_LTLIBRARIES = \
	libgnome-extimer.la

libgnome_extimer_la_VALASOURCES = \
	about-dialog.vala \
	accelerator.vala \
	aggregated-entry.vala \
	animation.vala \
	application.vala \
	capability-group.vala \
	capability-manager.vala \
	capability.vala \
	desktop-extension.vala \
	entry.vala \
	log-scale.vala \
	notifications-capability.vala \
	preferences-dialog.vala \
	presence.vala \
	screen-notification.vala \
	service.vala \
	settings.vala \
	stats-page.vala \
	stats-view.vala \
	stats-day-page.vala \
	stats-week-page.vala \
	stats-month-page.vala \
	timer.vala \
	timer-action-group.vala \
	timer-state.vala \
	utils.vala \
	window.vala

libgnome_extimer_la_SOURCES = \
	$(libgnome_extimer_la_VALASOURCES) \
	resources.c

libgnome_extimer_la_VALAFLAGS = \
	$(GNOME_POMODORO_VALAFLAGS) \
	--library=gnome-extimer \
	--header=gnome-extimer.h \
	--vapi=gnome-extimer.vapi \
	--gresources $(top_srcdir)/data/resources/resources.xml

libgnome_extimer_la_CPPFLAGS = \
	$(GNOME_POMODORO_CPPFLAGS) \
	-DGETTEXT_PACKAGE=\"$(GETTEXT_PACKAGE)\" \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

libgnome_extimer_la_CFLAGS = \
	$(GNOME_POMODORO_CFLAGS) \
	-w

libgnome_extimer_la_LIBADD = \
	$(GNOME_POMODORO_LIBS)

resources = \
	$(top_srcdir)/data/resources/resources.xml
resources_deps = \
	$(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/data/resources $(resources))

resources.c: $(resources) $(resources_deps)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --generate-source --c-name="extimer" --sourcedir=$(top_srcdir)/data/resources --target=$@ $<

BUILT_SOURCES = \
	resources.c

CLEANFILES = \
	$(BUILT_SOURCES) \
	$(libgnome_extimer_la_SOURCES:.vala=.c) \
	gnome-extimer.h \
	gnome-extimer.vapi \
	libgnome-extimer.la \
	libgnome_extimer_la_vala.stamp

EXTRA_DIST = \
	$(resources) \
	$(resources_deps) \
	gnome-extimer.h \
	gnome-extimer.deps \
	gnome-extimer.vapi

-include $(top_srcdir)/git.mk

# vi:ts=4:noet
