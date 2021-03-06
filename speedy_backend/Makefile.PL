
#
# Copyright (C) 2003  Sam Horrocks
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#

package SpeedyMake::speedy_backend;

require '../src/SpeedyMake.pl';
@ISA = 'SpeedyMake';

sub src_files_extra {'perl'}
sub src_files_o_extra {'xsinit.o'}
sub clean_files_full_extra {'xsinit'}
sub am_frontend {0}
sub my_name {'backend'}

sub remove_libs { my $class = shift;
    'BIN=speedy_backend ../util/remove_libs';
}

use ExtUtils::Embed;

my $tmp = "xsinit.tmp$$";

xsinit($tmp, 1, ['SpeedyCGI']);

open(I, $tmp)		|| die "${tmp}: $!\n";
open(O, '>xsinit.c')	|| die "xsinit.c: $!\n";
while (<I>) {
    if (/SpeedyCGI/) {
	if (/newXS.*SpeedyCGI/) {
	    print O "\t{extern void speedy_xs_init(); speedy_xs_init();}\n";
	}
    } else {
	print O $_;
    }
}
close(I) || die;
close(O) || die;
unlink $tmp;

SpeedyMake::speedy_backend->init->write_makefile;
