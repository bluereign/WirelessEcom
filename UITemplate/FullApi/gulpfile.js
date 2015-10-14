var gulp = require('gulp');
var less = require('gulp-less');
var fileinclude = require('gulp-file-include');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');
var connect = require('gulp-connect');
var npmcss = require('npm-css');


var paths = {
	html: ['*.html', 'views/*.html'],
	styles: ['stylesheets/*.less', 'stylesheets/*.css'],
	scripts: ['node_modules/jquery/dist/jquery.min.js', 'scripts/*.js']
};

gulp.task('connect', function() {
	connect.server({
		root: 'app',
		livereload: true
	});
});

gulp.task('fileinclude', function() {
	gulp.src(['*.html'])
		.pipe(fileinclude({
			prefix: '@@',
			basepath: '@file'
		}))
		.pipe(gulp.dest('./app'));
});

gulp.task('html', function () {
	gulp.src('*.html')
		.pipe(connect.reload());
});

gulp.task('build-less', function(){
	gulp.src('stylesheets/aafes-global.less')
		.pipe(less())
		.pipe(gulp.dest('app/stylesheets'))
		.pipe(connect.reload());
		
	return gulp.src('stylesheets/global.less')
		.pipe(less())
		.pipe(gulp.dest('app/stylesheets'))
		.pipe(connect.reload());
});

gulp.task('scripts', function() {
	// Minify and copy all JavaScript (except vendor scripts)
	// with sourcemaps all the way down
	return gulp.src(paths.scripts)
		.pipe(sourcemaps.init())
			.pipe(uglify())
			.pipe(concat('all.min.js'))
		.pipe(sourcemaps.write())
		.pipe(gulp.dest('app/scripts'))
		.pipe(connect.reload());
});

// Rerun the task when a file changes
gulp.task('watch', function() {
	gulp.watch(paths.html, ['html', 'fileinclude']);
	gulp.watch(paths.styles, ['build-less']);
	gulp.watch(paths.scripts, ['scripts']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['fileinclude', 'connect', 'watch', 'build-less', 'scripts']);