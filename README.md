<!---
 Copyright (c) 2018-2020 Steven Varga, Toronto,ON Canada
 Author: Varga, Steven <steven@vargaconsulting.ca>
--->

Source code transformation tool for HDF5 dataformat  H5CPP header only library  
----------------------------------------------------------------------------------------------------

This source code transformation tool simplifies the otherwise time consuming process of generating the shim code for HDF5 Compound datatypes by building the AST of a given TU translation unit, and identifying all POD datatypes referenced from H5CPP operators/functions.
The result is a seamless persistence much similar to python, java or other reflection based languages. 

The following excerpt shows the mechanism, how `vec` variable is marked by `h5::write` operator. When `h5cpp` tool is invoked it builds the full AST of the translation unit, finds the referenced types, then in topological order generates HDF5 COMPOUND datatype descriptors. The generated file has include guards, and meant to be used with [H5CPP template library](h5cpp.org). POD struct types may be arbitrary deep, embedded in POD C like arrays, and may be referenced from STL containers. Currently `stl::vector` is supported, but in time full support will be provided.

```cpp
...
std::vector<sn::example::Record> vec 
    = h5::utils::get_test_data<sn::example::Record>(20);
// mark vec  with an h5:: operator and delegate 
// the details to h5cpp compiler
h5::write(fd, "orm/partial/vector one_shot", vec );
...

// some include files with complex POD types, embedded in arbitrary name space
namespace sn {
	namespace typecheck {
		struct Record { /*the types with direct mapping to HDF5*/
			char  _char; unsigned char _uchar; short _short; unsigned short _ushort; int _int; unsigned int _uint;
			long _long; unsigned long _ulong; long long int _llong; unsigned long long _ullong;
			float _float; double _double; long double _ldouble;
			bool _bool;
			// wide characters are not supported in HDF5
			// wchar_t _wchar; char16_t _wchar16; char32_t _wchar32;
		};
	}
	namespace other {
		struct Record {                    // POD struct with nested namespace
			MyUInt                    idx; // typedef type 
			MyUInt                     aa; // typedef type 
			double            field_02[3]; // const array mapped 
			typecheck::Record field_03[4]; //
		};
	}
	namespace example {
		struct Record {                    // POD struct with nested namespace
			MyUInt                    idx; // typedef type 
			float             field_02[7]; // const array mapped 
			sn::other::Record field_03[5]; // embedded Record
			sn::other::Record field_04[5]; // must be optimized out, same as previous
			other::Record  field_05[3][8]; // array of arrays 
		};
	}
	namespace not_supported_yet {
		// NON POD: not supported in phase 1
		// C++ Class -> PODstruct -> persistence[ HDF5 | ??? ] -> PODstruct -> C++ Class 
		struct Container {
			double                            idx; // 
			std::string                  field_05; // c++ object makes it non-POD
			std::vector<example::Record> field_02; // ditto
		};
	}
	/* BEGIN IGNORED STRUCT */
	// these structs are not referenced with h5::read|h5::write|h5::create operators
	// hence compiler should ignore them.
	struct IgnoredRecord {
		signed long int   idx;
		float        field_0n;
	};
	/* END IGNORED STRUCTS */
```

Install:
----------
Only **LLVM 6.0 is supported**, to compile from  source you need both the llvm and clang-dev package installed:
```
sudo apt install llvm-6.0 llvm-6.0-dev libclang-6.0-dev  # 640MB space needed
make && make install                                     # compile the source code transforation tool
```
optionally you can remove the development libraries, and install only the runtime
```
sudo apt purge llvm-6.0 libllvm-6.0-dev libclang-6.0-dev # remove development libraries
sudo apt install libllvm6.0 libclang-common-6.0-dev      # install runtime dependencies
```

Caveat:
-------
All LLVM version other than 6.0 is failing, or crashing including the clang++ chain. This is being investigated, and once resolved this message
will be removed.

Usage:
-------
`h5cpp  your_translation_unit.cpp -- -v $(CXXFLAGS)  -Dgenerated.h`
will run the compiler front end on the specified input, and outputs the necessary HDF5 type descriptors, or 
the error message if any.



[hdf5]: https://support.hdfgroup.org/HDF5/doc/H5.intro.html
[1]: http://en.cppreference.com/w/cpp/container/vector
[2]: http://arma.sourceforge.net
[4]: https://support.hdfgroup.org/HDF5/doc/RM/RM_H5Front.html
[5]: https://support.hdfgroup.org/HDF5/release/obtain5.html
[6]: http://eigen.tuxfamily.org/index.php?title=Main_Page
[7]: http://www.boost.org/doc/libs/1_65_1/libs/numeric/ublas/doc/matrix.htm
[8]: https://julialang.org/
[9]: https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_.28CSR.2C_CRS_or_Yale_format.29
[10]: https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_.28CSC_or_CCS.29
[11]: https://en.wikipedia.org/wiki/List_of_numerical_libraries#C++
[12]: http://en.cppreference.com/w/cpp/concept/StandardLayoutType
[40]: https://support.hdfgroup.org/HDF5/Tutor/HDF5Intro.pdf
[99]: https://en.wikipedia.org/wiki/C_(programming_language)#Pointers
[100]: http://arma.sourceforge.net/
[101]: http://www.boost.org/doc/libs/1_66_0/libs/numeric/ublas/doc/index.html
[102]: http://eigen.tuxfamily.org/index.php?title=Main_Page#Documentation
[103]: https://sourceforge.net/projects/blitz/
[104]: https://sourceforge.net/projects/itpp/
[105]: http://dlib.net/linear_algebra.html
[106]: https://bitbucket.org/blaze-lib/blaze
[107]: https://github.com/wichtounet/etl
[200]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_profiling_README.html
[201]: http://h5cpp.org/examples.html
[202]: http://h5cpp.org/modules.html
[305]: md__home_steven_Documents_projects_h5cpp_docs_pages_compiler_trial.html#link_try_compiler
[400]: https://www.meetup.com/Chicago-C-CPP-Users-Group/events/250655716/
[401]: https://www.hdfgroup.org/2018/07/cpp-has-come-a-long-way-and-theres-plenty-in-it-for-users-of-hdf5/
[999]: http://h5cpp.org/cgi/redirect.py
[301]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_docs_pages_conversion.html
[302]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_docs_pages_exceptions.html
[303]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_docs_pages_compiler.html
[304]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_docs_pages_linalg.html
[305]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_docs_pages_install.html
[400]: http://h5cpp.org/md__home_steven_Documents_projects_h5cpp_docs_pages_error_handling.html
