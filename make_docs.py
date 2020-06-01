import os
import sys
import subprocess
import errno


def create_tmp():
    curr_dir = os.path.dirname(os.path.abspath(__file__))
    loc = curr_dir.find('autotest-rf')
    if loc == -1:
        print('The path does not contain the folder "autotest".')
        sys.exit()
    root_dir = curr_dir[:loc + len('autotest')]

    auts = get_immediate_subdirectories(root_dir + '/aut')
    for aut in auts:
        make_folder(root_dir + '/tmp/doc/' + aut)

        # Generate test docs
        f = root_dir + '/aut/' + aut
        o = root_dir + '/tmp/doc/' + aut + '/' + aut + '_Tests.html'
        subprocess.call(['python', '-m', 'robot.testdoc', f, o])

        # Generate keywords docs
        for cur, dirs, files in os.walk(root_dir + '/aut/' + aut):
            print(cur)
            print(dirs)
            print(' --- ' + os.path.basename(cur))
            print(os.path.basename(cur) + '_Keywords.txt' in files)

            if os.path.basename(cur) + '_Keywords.txt' in files:
                f = cur + '/' + os.path.basename(cur) + '_Keywords.txt'
                o = root_dir + '/tmp/doc/' + aut + '/' + os.path.basename(cur) + '_Keywords.html'
                subprocess.call(['python', '-m', 'robot.libdoc', f, o])


def get_immediate_subdirectories(dir):
    return [name for name in os.listdir(dir)
            if os.path.isdir(os.path.join(dir, name))]


def make_folder(path):
    try:
        os.makedirs(path)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise


if __name__ == '__main__':
    create_tmp()

