noinst_SCRIPTS = \
	gnome-extimer-jhbuild

SUBST=sed \
	-e "s|[@]abs_srcdir[@]|$(abs_srcdir)|g" \
	-e "s|[@]abs_top_srcdir[@]|$(abs_top_srcdir)|g"

gnome-extimer-jhbuild: gnome-extimer-jhbuild.in
	$(AM_V_GEN) $(SUBST) < $< > $@
	chmod +x $@

EXTRA_DIST = \
	gnome-extimer-jhbuild.in

CLEANFILES = \
	gnome-extimer-jhbuild

-include $(top_srcdir)/git.mk

# vi:ts=4:noet
