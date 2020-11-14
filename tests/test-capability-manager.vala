/*
 * This file is part of GNOME ExTimer
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

namespace ExTimer
{
    public class CapabilityManagerTest : ExTimer.TestSuite
    {
        public CapabilityManagerTest ()
        {
            this.add_test ("add_group",
                           this.test_add_group);

            this.add_test ("remove_group",
                           this.test_remove_group);

            this.add_test ("enable",
                           this.test_enable);

            this.add_test ("enable_2",
                           this.test_enable_2);

            this.add_test ("enable_3",
                           this.test_enable_3);

            this.add_test ("fallback_add_group",
                           this.test_fallback_add_group);

            this.add_test ("fallback_remove_group",
                           this.test_fallback_remove_group);

            this.add_test ("fallback_capability_added",
                           this.test_fallback_capability_added);

            this.add_test ("fallback_capability_removed",
                           this.test_fallback_capability_removed);

            this.add_test ("dispose",
                           this.test_dispose);
        }

        public override void setup ()
        {
        }

        public override void teardown ()
        {
        }

        /**
         * Unit test for ExTimer.Capability.is_virtual() method.
         */
        public void test_add_group ()
        {
            var capability = new ExTimer.Capability ("anti-gravity");
            var group      = new ExTimer.CapabilityGroup ();
            var manager    = new ExTimer.CapabilityManager ();

            group.add (capability);
            manager.add_group (group, ExTimer.Priority.DEFAULT);

            assert (manager.has_group (group));
            assert (manager.has_capability ("anti-gravity"));
            assert (!capability.enabled);
        }

        public void test_remove_group ()
        {
            var capability = new ExTimer.Capability ("anti-gravity");
            var group      = new ExTimer.CapabilityGroup ();
            var manager    = new ExTimer.CapabilityManager ();

            group.add (capability);
            manager.enable ("anti-gravity");

            manager.add_group (group, ExTimer.Priority.DEFAULT);
            assert (manager.has_capability ("anti-gravity"));
            assert (capability.enabled);

            manager.remove_group (group);
            assert (!manager.has_capability ("anti-gravity"));
            assert (!capability.enabled);
        }

        /**
         */
        public void test_enable ()
        {
            var capability = new ExTimer.Capability ("anti-gravity");
            var group      = new ExTimer.CapabilityGroup ();
            var manager    = new ExTimer.CapabilityManager ();

            group.add (capability);
            manager.add_group (group, ExTimer.Priority.DEFAULT);

            manager.enable ("anti-gravity");
            assert (capability.enabled);

            manager.disable ("anti-gravity");
            assert (!capability.enabled);
        }

        /**
         * Test if initial "enabled" value is handled by manager.
         */
        public void test_enable_2 ()
        {
            var capability = new ExTimer.Capability ("anti-gravity");
            var group      = new ExTimer.CapabilityGroup ();
            var manager    = new ExTimer.CapabilityManager ();

            capability.enable ();

            group.add (capability);
            manager.add_group (group, ExTimer.Priority.DEFAULT);

            assert (!capability.enabled);
        }

        /**
         * Test if "enabled" value is saved independently from Capability.enabled.
         */
        public void test_enable_3 ()
        {
            var capability = new ExTimer.Capability ("anti-gravity");
            var group      = new ExTimer.CapabilityGroup ();
            var manager    = new ExTimer.CapabilityManager ();

            manager.enable ("anti-gravity");

            group.add (capability);
            manager.add_group (group, ExTimer.Priority.DEFAULT);

            assert (capability.enabled);
        }

        /**
         * Test falling back during add_group()
         */
        public void test_fallback_add_group ()
        {
            var manager = new ExTimer.CapabilityManager ();

            var capability1 = new ExTimer.Capability ("anti-gravity");
            var group1      = new ExTimer.CapabilityGroup ();

            var capability2 = new ExTimer.Capability ("anti-gravity");
            var group2      = new ExTimer.CapabilityGroup ();

            group1.add (capability1);
            group2.add (capability2);

            manager.add_group (group1, ExTimer.Priority.DEFAULT);
            manager.add_group (group2, ExTimer.Priority.HIGH);

            manager.enable ("anti-gravity");

            assert (manager.get_preferred_capability ("anti-gravity") == capability2);
            assert (capability2.enabled);
            assert (!capability1.enabled);
        }

        /**
         * Test falling back during remove_group()
         */
        public void test_fallback_remove_group ()
        {
            var manager = new ExTimer.CapabilityManager ();

            var capability1 = new ExTimer.Capability ("anti-gravity");
            var group1      = new ExTimer.CapabilityGroup ();

            var capability2 = new ExTimer.Capability ("anti-gravity");
            var group2      = new ExTimer.CapabilityGroup ();

            group1.add (capability1);
            group2.add (capability2);

            manager.add_group (group1, ExTimer.Priority.DEFAULT);
            manager.add_group (group2, ExTimer.Priority.HIGH);

            manager.enable ("anti-gravity");

            assert (manager.get_preferred_capability ("anti-gravity") == capability2);
            assert (capability2.enabled);
            assert (!capability1.enabled);

            manager.remove_group (group2);
            assert (manager.get_preferred_capability ("anti-gravity") == capability1);
            assert (!capability2.enabled);
            assert (capability1.enabled);
        }

        /**
         * Test falling back during "capability-added" signal.
         */
        public void test_fallback_capability_added ()
        {
            var manager = new ExTimer.CapabilityManager ();

            var capability1 = new ExTimer.Capability ("anti-gravity");
            var group1      = new ExTimer.CapabilityGroup ();

            var capability2 = new ExTimer.Capability ("anti-gravity");
            var group2      = new ExTimer.CapabilityGroup ();

            manager.add_group (group1, ExTimer.Priority.DEFAULT);
            manager.add_group (group2, ExTimer.Priority.HIGH);

            group1.add (capability1);
            group2.add (capability2);

            manager.enable ("anti-gravity");

            assert (manager.get_preferred_capability ("anti-gravity") == capability2);
            assert (capability2.enabled);
            assert (!capability1.enabled);
        }

        /**
         * Test falling back during "capability-remove" signal.
         */
        public void test_fallback_capability_removed ()
        {
            var manager = new ExTimer.CapabilityManager ();

            var capability1 = new ExTimer.Capability ("anti-gravity");
            var group1      = new ExTimer.CapabilityGroup ();

            var capability2 = new ExTimer.Capability ("anti-gravity");
            var group2      = new ExTimer.CapabilityGroup ();

            group1.add (capability1);
            group2.add (capability2);

            manager.add_group (group1, ExTimer.Priority.DEFAULT);
            manager.add_group (group2, ExTimer.Priority.HIGH);

            manager.enable ("anti-gravity");

            assert (manager.get_preferred_capability ("anti-gravity") == capability2);
            assert (capability2.enabled);
            assert (!capability1.enabled);

            group2.remove ("anti-gravity");
            assert (manager.get_preferred_capability ("anti-gravity") == capability1);
            assert (!capability2.enabled);
            assert (capability1.enabled);
        }

        /**
         * Unit test for ExTimer.CapabilityManager.dispose() method.
         */
        public void test_dispose ()
        {
            var capability = new ExTimer.Capability ("anti-gravity");
            var group      = new ExTimer.CapabilityGroup ();
            var manager    = new ExTimer.CapabilityManager ();

            manager.enable ("anti-gravity");

            group.add (capability);
            manager.add_group (group, ExTimer.Priority.DEFAULT);

            manager.dispose ();

            assert (!capability.enabled);
        }
    }
}
