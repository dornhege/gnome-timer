bin_PROGRAMS = \
	gnome-extimer

gnome_extimer_SOURCES = \
	main.vala \
	$(top_builddir)/lib/gnome-extimer.vapi

gnome_extimer_VALAFLAGS = \
	$(GNOME_POMODORO_VALAFLAGS) \
	--pkg posix

gnome_extimer_CPPFLAGS = \
	$(GNOME_POMODORO_CPPFLAGS) \
	-DGETTEXT_PACKAGE=\"$(GETTEXT_PACKAGE)\" \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

gnome_extimer_CFLAGS = \
	$(GNOME_POMODORO_CFLAGS) \
	-w

gnome_extimer_LDADD = \
	$(GNOME_POMODORO_LIBS) \
	$(top_builddir)/lib/libgnome-extimer.la


CLEANFILES = \
	$(gnome_extimer_SOURCES:.vala=.c) \
	gnome-extimer \
	gnome_extimer_vala.stamp

-include $(top_srcdir)/git.mk

# vi:ts=4:noet
