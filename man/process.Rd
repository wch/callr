% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/process-process.R
\name{process}
\alias{process}
\title{External process}
\description{
Managing external processes from R is not trivial, and this
class aims to help with this deficiency. It is essentially a small
wrapper around the \code{system} base R function, to return the process
id of the started process, and set its standard output and error
streams. The process id is then used to manage the process.
}
\section{Usage}{
\preformatted{p <- process$new(command = NULL, args,
                 stdout = NULL, stderr = NULL, cleanup = TRUE,
                 echo_cmd = FALSE, supervise = FALSE,
                 windows_verbatim_args = FALSE,
                 windows_hide_window = FALSE,
                 encoding = "", post_process = NULL)

p$is_alive()
p$signal(signal)
p$kill(grace = 0.1)
p$wait(timeout = -1)
p$get_pid()
p$get_exit_status()
p$restart()
p$get_start_time()

p$read_output(n = -1)
p$read_error(n = -1)
p$read_output_lines(n = -1)
p$read_error_lines(n = -1)
p$get_output_connection()
p$get_error_connection()
p$is_incomplete_output()
p$is_incomplete_error()
p$read_all_output()
p$read_all_error()
p$read_all_output_lines()
p$read_all_error_lines()

p$poll_io(timeout)

p$get_result()

print(p)
}
}

\section{Arguments}{

\itemize{
\item \code{p}: \code{process} object.
\item \code{command}: Character scalar, the command to run.
Note that this argument is not passed to a shell, so no
tilde-expansion or variable substitution is performed on it.
It should not be quoted with \code{\link[base:shQuote]{base::shQuote()}}. See
\code{\link[base:normalizePath]{base::normalizePath()}} for tilde-expansion.
\item \code{args}: Character vector, arguments to the command. They will be
used as is, without a shell. They don't need to be escaped.
\item \code{stdout}: What to do with the standard output. Possible values:
\code{NULL}: discard it; a string, redirect it to this file;
\code{"|"}: create a connection for it.
\item \code{stderr}: What to do with the standard error. Possible values:
\code{NULL}: discard it; a string, redirect it to this file;
\code{"|"}: create a connection for it.
\item \code{cleanup}: Whether to kill the process (and its children)
if the \code{process} object is garbage collected.
\item \code{echo_cmd}: Whether to print the command to the screen before
running it.
\item \code{supervise}: Whether to register the process with a supervisor.
If \code{TRUE}, the supervisor will ensure that the process is
killed when the R process exits.
\item \code{windows_verbatim_args}: Whether to omit quoting the arguments
on Windows. It is ignored on other platforms.
\item \code{windows_hide_window}: Whether to hide the application's window
on Windows. It is ignored on other platforms.
\item \code{signal}: An integer scalar, the id of the signal to send to
the process. See \code{\link[tools:pskill]{tools::pskill()}} for the list of signals.
\item \code{grace}: Currently not used.
\item \code{timeout}: Timeout in milliseconds, for the wait or the I/O
polling.
\item \code{n}: Number of characters or lines to read.
\item \code{encoding}: The encoding to assume for \code{stdout} and
\code{stderr}. By default the encoding of the current locale is
used. Note that \code{callr} always reencodes the output of
both streams in UTF-8 currently. If you want to read them
without any conversion, on all platforms, specify \code{"UTF-8"} as
encoding.
\item \code{post_process}: An optional function to run when the process has
finished. Currently it only runs if \code{$get_result()} is called.
It is only run once.
}
}

\section{Details}{

\code{$new()} starts a new process in the background, and then returns
immediately.

\code{$is_alive()} checks if the process is alive. Returns a logical
scalar.

\code{$signal()} sends a signal to the process. On Windows only the
\code{SIGINT}, \code{SIGTERM} and \code{SIGKILL} signals are interpreted,
and the special 0 signal, The first three all kill the process. The 0
signal return \code{TRUE} if the process is alive, and \code{FALSE}
otherwise. On Unix all signals are supported that the OS supports, and
the 0 signal as well.

\code{$kill()} kills the process. It also kills all of its child
processes, except if they have created a new process group (on Unix),
or job object (on Windows). It returns \code{TRUE} if the process
was killed, and \code{FALSE} if it was no killed (because it was
already finished/dead when \code{callr} tried to kill it).

\code{$wait()} waits until the process finishes, or a timeout happens.
Note that if the process never finishes, and the timeout is infinite
(the default), then R will never regain control. It returns
the process itself, invisibly.

\code{$get_pid()} returns the process id of the process.

\code{$get_exit_status} returns the exit code of the process if it has
finished and \code{NULL} otherwise.

\code{$restart()} restarts a process. It returns the process itself.

\code{$get_start_time()} returns the time when the process was
started.

\code{$is_supervised()} returns whether the process is being tracked by
supervisor process.

\code{$supervise()} if passed \code{TRUE}, tells the supervisor to start
tracking the process. If \code{FALSE}, tells the supervisor to stop
tracking the process. Note that even if the supervisor is disabled for a
process, if it was started with \code{cleanup=TRUE}, the process will
still be killed when the object is garbage collected.

\code{$read_output()} reads from the standard output connection of the
process. If the standard output connection was not requested, then
then it returns an error. It uses a non-blocking text connection. This
will work only if \code{stdout="|"} was used. Otherwise, it will throw an
error.

\code{$read_error()} is similar to \code{$read_output}, but it reads
from the standard error stream.

\code{$read_output_lines()} reads lines from standard output connection
of the process. If the standard output connection was not requested, then
then it returns an error. It uses a non-blocking text connection. This
will work only if \code{stdout="|"} was used. Otherwise, it will throw an
error.

\code{$read_error_lines()} is similar to \code{$read_output_lines}, but
it reads from the standard error stream.

\code{$has_output_connection()} returns \code{TRUE} if there is a connection
object for standard output; in other words, if \code{stdout="|"}. It returns
\code{FALSE} otherwise.

\code{$has_error_connection()} returns \code{TRUE} if there is a connection
object for standard error; in other words, if \code{stderr="|"}. It returns
\code{FALSE} otherwise.

\code{$get_output_connection()} returns a connection object, to the
standard output stream of the process.

\code{$get_error_conneciton()} returns a connection object, to the
standard error stream of the process.

\code{$is_incomplete_output()} return \code{FALSE} if the other end of
the standard output connection was closed (most probably because the
process exited). It return \code{TRUE} otherwise.

\code{$is_incomplete_error()} return \code{FALSE} if the other end of
the standard error connection was closed (most probably because the
process exited). It return \code{TRUE} otherwise.

\code{$read_all_output()} waits for all standard output from the process.
It does not return until the process has finished.
Note that this process involves waiting for the process to finish,
polling for I/O and potentically several \code{readLines()} calls.
It returns a character scalar. This will return content only if
\code{stdout="|"} was used. Otherwise, it will throw an error.

\code{$read_all_error()} waits for all standard error from the process.
It does not return until the process has finished.
Note that this process involves waiting for the process to finish,
polling for I/O and potentically several \code{readLines()} calls.
It returns a character scalar. This will return content only if
\code{stderr="|"} was used. Otherwise, it will throw an error.

\code{$read_all_output_lines()} waits for all standard output lines
from a process. It does not return until the process has finished.
Note that this process involves waiting for the process to finish,
polling for I/O and potentically several \code{readLines()} calls.
It returns a character vector. This will return content only if
\code{stdout="|"} was used. Otherwise, it will throw an error.

\code{$read_all_error_lines()} waits for all standard error lines from
a process. It does not return until the process has finished.
Note that this process involves waiting for the process to finish,
polling for I/O and potentically several \code{readLines()} calls.
It returns a character vector. This will return content only if
\code{stderr="|"} was used. Otherwise, it will throw an error.

\code{$get_output_file()} if the \code{stdout} argument was a filename,
this returns the absolute path to the file. If \code{stdout} was \code{"|"} or
\code{NULL}, this simply returns that value.

\code{$get_error_file()} if the \code{stderr} argument was a filename,
this returns the absolute path to the file. If \code{stderr} was \code{"|"} or
\code{NULL}, this simply returns that value.

\code{$poll_io()} polls the process's connections for I/O. See more in
the \emph{Polling} section, and see also the \code{\link[=poll]{poll()}} function
to poll on multiple processes.

\code{$get_result()} returns the result of the post processesing function.
It can only be called once the process has finished. If the process has
no post-processing function, then \code{NULL} is returned.

\code{print(p)} or \code{p$print()} shows some information about the
process on the screen, whether it is running and it's process id, etc.
}

\section{Polling}{

The \code{poll_io()} function polls the standard output and standard
error connections of a process, with a timeout. If there is output
in either of them, or they are closed (e.g. because the process exits)
\code{poll_io()} returns immediately.

In addition to polling a single process, the \code{\link[=poll]{poll()}} function
can poll the output of several processes, and returns as soon as any
of them has generated output (or exited).
}

\examples{
# CRAN does not like long-running examples
\dontrun{
p <- process$new("sleep", "2")
p$is_alive()
p
p$kill()
p$is_alive()

p$restart()
p$is_alive()
Sys.sleep(3)
p$is_alive()
}

}
