// simple program to compress LUA files for Pico-8
const fs = require('fs');
const { resolve } = require('path');

// get file paths; main_dir is one directory above
const main_dir = resolve('../')+'/';
const out_dir = resolve('./output/');

// utility to parse nested dirs as a path string
const parse_nests = (nests) => nests.length ? nests.join('/') + '/' : '';
// filter to only retrieve LUA, p8, and directories from one directory above
const filter = (f) => f.name != 'compressor' && !f.name.startsWith('_') && !f.name.startsWith('.') && (f.name.endsWith('.lua') || f.name.endsWith('.p8') || f.isDirectory());

// get the top-level of files and directories
const parent_dir = fs.readdirSync(main_dir,{withFileTypes:true}).filter(filter)


/**
 * Copy all nested LUA files into the output directory.
 * @param {fs.Dirent[]} dirents 
 * @param {string[]?} nests
 */
function copy_and_compress(dirents, nests=[]) {
    dirents.forEach((dir) => {
        
        // recursive descent if directory
        if (dir.isDirectory()) {
            const new_nests = [...nests,dir.name];
            return copy_and_compress(fs.readdirSync(main_dir+(parse_nests(new_nests)),{withFileTypes:true}).filter(filter), new_nests)
        }
        
        // else, copy over to output, creating any necessary nested directories
        const nested_directory = `${out_dir}/${nests.join('/')}`;
        if (nests.length && !fs.existsSync(nested_directory)) {
            fs.mkdirSync(nested_directory, {recursive:true});
        }

        // finally, read file from source and write new compressed file
        const file_contents = fs.readFileSync(`${main_dir}${parse_nests(nests)}${dir.name}`);

        // write pico8 file with _compressed file name
        if (dir.name.endsWith('.p8')) {
            const new_name = dir.name.split('.').slice(0,-1) + '_compressed.p8'
            fs.copyFileSync(
                `${main_dir}${parse_nests(nests)}${dir.name}`,
                `${nested_directory}/${new_name}`
            );
            return;
        }

        // write to file with compressed LUA file contents
        // console.log(`Compressing\n\t${parse_nests(nests)}${dir.name}`);
        console.log(`Compressing ${dir.name}`);
        fs.writeFileSync(`${nested_directory}/${dir.name}`, file_contents.toString().split('\n')
            .map(s => s
                .replace(/\-\-.*/g,'')        // comments
                .replace(/^[\s\t]*/g,'')      // indentions
                .replace(/[\t]*/g,'')         // tabs
                .replace(/ [ ]*$/g,' ') // trailing spaces
                .replace(/(\r\n|\r|\n)/g,'')  // newlines
            )
            .filter((s) => s.length)
            .join(' ')
            // .replace(/ [ ]+/g, ' ') // excessive spaces
            .replace(/\s*(,|\+|-|\*|\/|\{|\}|\(|\)|\=|(==)|(>=)|(<=)|(~=))[\s]*/g, '$1') // remove spacing around operations
        );
    });
}

// create output dir if needed
if (!fs.existsSync(out_dir))
    fs.mkdirSync(out_dir);

// begin copying files over
console.log('Compressing files from source.');
console.log('------------------------------');
copy_and_compress(parent_dir);
console.log('Done!\n\nAll LUA files compressed.');